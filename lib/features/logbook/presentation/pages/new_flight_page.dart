import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for creating a new flight entry
/// Contains fields: Flight, Date, Airline Route with search
class NewFlightPage extends StatefulWidget {
  const NewFlightPage({super.key});

  @override
  State<NewFlightPage> createState() => _NewFlightPageState();
}

class _NewFlightPageState extends State<NewFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _flightController = TextEditingController();
  final _routeSearchController = TextEditingController();
  DateTime? _selectedDate;
  AirlineRouteEntity? _selectedRoute;
  String _routeSearchQuery = '';
  List<AirlineRouteEntity> _airlineRoutes = [];
  bool _isLoadingRoutes = true;
  String? _errorMessage;

  // Logbook ID (fetched automatically)
  String? _logbookId;

  // Edit mode — data passed from Daily Logbook Detail
  Map<String, dynamic>? _editArgs;
  bool _isEditMode = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Load airline routes for search
    context.read<EmployeeBloc>().add(LoadEmployeeAirlineRoutes());
    // Fetch logbook ID for the employee
    context.read<FlightBloc>().add(const FetchLogbookId());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _parseEditArguments();
    }
  }

  /// Parse route arguments for edit mode
  void _parseEditArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.isNotEmpty) {
      _editArgs = args;
      _isEditMode = true;
      _prefillFromArgs();
    }
  }

  /// Pre-fill flight number, date, and logbook ID from edit args
  void _prefillFromArgs() {
    final args = _editArgs!;

    // Flight number
    if (args['flight_number'] != null) {
      _flightController.text = args['flight_number'].toString();
    }

    // Date
    if (args['flight_real_date'] is DateTime) {
      _selectedDate = args['flight_real_date'] as DateTime;
    }

    // Logbook ID
    if (args['daily_logbook_id'] != null) {
      _logbookId = args['daily_logbook_id'].toString();
    }
  }

  /// Try to auto-select the matching airline route from loaded routes
  void _tryAutoSelectRoute() {
    if (_editArgs == null || _airlineRoutes.isEmpty) return;
    final routeId = _editArgs!['airline_route_id'];
    if (routeId == null) return;

    // Try matching by airline_route_id first
    final match = _airlineRoutes.cast<AirlineRouteEntity?>().firstWhere(
      (r) => r!.id == routeId || r.uuid == routeId,
      orElse: () => null,
    );

    if (match != null) {
      setState(() => _selectedRoute = match);
      return;
    }

    // Fallback: match by origin + destination IATA codes
    final origin = _editArgs!['origin_iata_code'];
    final dest = _editArgs!['destination_iata_code'];
    if (origin != null && dest != null) {
      final fallbackMatch = _airlineRoutes
          .cast<AirlineRouteEntity?>()
          .firstWhere(
            (r) =>
                r!.originAirportCode == origin &&
                r.destinationAirportCode == dest,
            orElse: () => null,
          );
      if (fallbackMatch != null) {
        setState(() => _selectedRoute = fallbackMatch);
      }
    }
  }

  @override
  void dispose() {
    _flightController.dispose();
    _routeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeAirlineRoutesSuccess) {
              setState(() {
                _airlineRoutes = state.response.data;
                _isLoadingRoutes = false;
                _errorMessage = null;
              });
              // Auto-select route in edit mode after routes load
              if (_isEditMode) {
                _tryAutoSelectRoute();
              }
            } else if (state is EmployeeAirlineRoutesLoading) {
              setState(() {
                _isLoadingRoutes = true;
                _errorMessage = null;
              });
            } else if (state is EmployeeError) {
              setState(() {
                _isLoadingRoutes = false;
                _errorMessage = state.message;
              });
            }
          },
        ),
        BlocListener<FlightBloc, FlightState>(
          listener: (context, state) {
            if (state is LogbookIdLoaded) {
              setState(() {
                _logbookId = state.logbookId;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    label: 'Flight',
                    hint: 'Enter flight number (1-4 digits)',
                    controller: _flightController,
                    prefixIcon: Icons.flight,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDateField(),
                  const SizedBox(height: 20),
                  _buildRouteSearchField(),
                  const SizedBox(height: 20),
                  _buildRouteResultsArea(),
                  const SizedBox(height: 32),
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1a1a2e)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        _isEditMode ? 'Edit Flight' : 'New Flight',
        style: const TextStyle(
          color: Color(0xFF1a1a2e),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: const TextStyle(
            color: Color(0xFF6c757d),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF6c757d)),
              prefixIcon:
                  prefixIcon != null
                      ? Icon(prefixIcon, color: const Color(0xFF6c757d))
                      : null,
              border: InputBorder.none,
              counterText: '', // Hide the character counter
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator:
                isRequired
                    ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    }
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date *',
          style: TextStyle(
            color: Color(0xFF6c757d),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF6c757d)),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'Select date',
                  style: TextStyle(
                    color:
                        _selectedDate != null
                            ? const Color(0xFF1a1a2e)
                            : const Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Airline Route *',
          style: TextStyle(
            color: Color(0xFF6c757d),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _routeSearchController,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [_UpperCaseTextFormatter()],
            onChanged: (value) {
              setState(() => _routeSearchQuery = value);
            },
            decoration: InputDecoration(
              hintText: 'Search route...',
              hintStyle: const TextStyle(color: Color(0xFF6c757d)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6c757d)),
              suffixIcon:
                  _routeSearchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF6c757d)),
                        onPressed: () {
                          _routeSearchController.clear();
                          setState(() => _routeSearchQuery = '');
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteResultsArea() {
    // Filter routes by search query
    final filteredRoutes =
        _routeSearchQuery.isEmpty
            ? _airlineRoutes
            : _airlineRoutes.where((route) {
              final origin = (route.originAirportCode ?? '').toLowerCase();
              final dest = (route.destinationAirportCode ?? '').toLowerCase();
              final airlineName = (route.airlineName ?? '').toLowerCase();
              final routeCode =
                  '${route.originAirportCode ?? ''}-${route.destinationAirportCode ?? ''}'
                      .toLowerCase();
              final query = _routeSearchQuery.toLowerCase();
              return origin.contains(query) ||
                  dest.contains(query) ||
                  airlineName.contains(query) ||
                  routeCode.contains(query);
            }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected route if any
        if (_selectedRoute != null) ...[
          _buildSelectedRouteCard(),
          const SizedBox(height: 16),
          // Button to change route
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedRoute = null;
                });
              },
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Change Route'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4facfe),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Routes list with scroll
        Container(
          width: double.infinity,
          height: 250, // Fixed height for scrollable area
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFe0e0e0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              _isLoadingRoutes
                  ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4facfe)),
                  )
                  : filteredRoutes.isEmpty
                  ? _buildEmptyRoutesPlaceholder()
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredRoutes.length,
                      itemBuilder: (context, index) {
                        final route = filteredRoutes[index];
                        final isSelected = _selectedRoute?.id == route.id;
                        return _buildRouteListItem(
                          route,
                          isSelected: isSelected,
                        );
                      },
                    ),
                  ),
        ),

        // Routes count indicator
        if (!_isLoadingRoutes && filteredRoutes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${filteredRoutes.length} route${filteredRoutes.length != 1 ? 's' : ''} available',
              style: const TextStyle(color: Color(0xFF6c757d), fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyRoutesPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _errorMessage != null ? Icons.error_outline : Icons.flight,
              color:
                  _errorMessage != null
                      ? const Color(0xFFe17055)
                      : const Color(0xFF6c757d),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ??
                  (_airlineRoutes.isEmpty
                      ? 'No routes available for your airline'
                      : 'Search for a route above'),
              style: TextStyle(
                color:
                    _errorMessage != null
                        ? const Color(0xFFe17055)
                        : const Color(0xFF6c757d),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  context.read<EmployeeBloc>().add(LoadEmployeeAirlineRoutes());
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4facfe),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRouteListItem(
    AirlineRouteEntity route, {
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRoute = route;
          _routeSearchController.clear();
          _routeSearchQuery = '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4facfe).withOpacity(0.1) : null,
          border: const Border(bottom: BorderSide(color: Color(0xFFe9ecef))),
        ),
        child: Row(
          children: [
            Icon(
              Icons.flight,
              color:
                  isSelected
                      ? const Color(0xFF4facfe)
                      : const Color(0xFF6c757d),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${route.originAirportCode ?? '???'} → ${route.destinationAirportCode ?? '???'}',
                    style: TextStyle(
                      color:
                          isSelected
                              ? const Color(0xFF4facfe)
                              : const Color(0xFF1a1a2e),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    route.airlineName ?? 'Unknown Airline',
                    style: const TextStyle(
                      color: Color(0xFF6c757d),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF4facfe)
                        : const Color(0xFF4facfe).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                color: isSelected ? Colors.white : const Color(0xFF4facfe),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRouteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.flight, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedRoute!.originAirportCode ?? '???'} → ${_selectedRoute!.destinationAirportCode ?? '???'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _selectedRoute!.airlineName ?? 'Unknown Airline',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() => _selectedRoute = null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4facfe).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CONTINUE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4facfe),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1a1a2e),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a date'),
            backgroundColor: const Color(0xFFe17055),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      if (_selectedRoute == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an airline route'),
            backgroundColor: const Color(0xFFe17055),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Navigate to License Plate lookup (Step 2)
      // POST /daily-logbooks/:id/details needs: flight_real_date, flight_number, airline_route_id
      // The backend resolves route_code, origin/destination iata, airline_code from airline_route_id
      final flightData = <String, dynamic>{
        'daily_logbook_id': _logbookId ?? '',
        'flight_real_date':
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        'flight_number': _flightController.text.trim(),
        'airline_route_id': _selectedRoute!.id,
      };

      Navigator.pushNamed(context, '/license-plate', arguments: flightData);
    }
  }
}

/// TextInputFormatter that converts all text to uppercase
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
