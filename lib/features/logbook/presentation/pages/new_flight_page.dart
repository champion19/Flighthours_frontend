import 'package:flight_hours_app/core/responsive/responsive_padding.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
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
  final _originSearchController = TextEditingController();
  final _destinationSearchController = TextEditingController();
  DateTime? _selectedDate;
  AirlineRouteEntity? _selectedRoute;
  List<AirlineRouteEntity> _airlineRoutes = [];
  bool _isLoadingRoutes = true;
  String? _errorMessage;

  // Set when the origin/destination pair has a physical route but no active
  // link to the employee's airline yet — the backend auto-creates it as
  // "pending" and an admin has to approve it before it's usable here.
  bool _isResolvingRoute = false;
  AirlineRouteEntity? _pendingRoute;

  // Origin/destination airport pickers
  List<AirportEntity> _airports = [];
  bool _isLoadingAirports = true;
  AirportEntity? _selectedOrigin;
  AirportEntity? _selectedDestination;
  String _originQuery = '';
  String _destinationQuery = '';

  // Logbook ID (fetched automatically)
  String? _logbookId;

  // Tail number already captured for this book page ("New Logbook Entry"),
  // if any — carried forward so it doesn't need to be asked again.
  String? _prefillTailNumber;

  // Edit mode — data passed from Daily Logbook Detail
  Map<String, dynamic>? _editArgs;
  bool _isEditMode = false;
  bool _initialized = false;

  // True while silently creating the flight with the book page's tail
  // number, skipping the tail number screen entirely.
  bool _isSavingWithKnownTailNumber = false;

  @override
  void initState() {
    super.initState();
    // Load airline routes for search
    context.read<EmployeeBloc>().add(LoadEmployeeAirlineRoutes());
    // Load airports for the origin/destination pickers
    context.read<AirportBloc>().add(FetchAirports());
    // Fetch logbook ID for the employee
    context.read<FlightBloc>().add(const FetchLogbookId());
    // Keep the AppBar title (flight number) in sync as the user types
    _flightController.addListener(() => setState(() {}));
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
      // Only enter edit mode if actual flight data is present
      final hasFlightData =
          args.containsKey('flight_number') ||
          args.containsKey('detail_id') ||
          args.containsKey('flight_real_date');
      if (hasFlightData) {
        _editArgs = args;
        _isEditMode = true;
        _prefillFromArgs();
      } else if (args['daily_logbook_id'] != null) {
        // Logbook context only — set the ID without entering edit mode
        _logbookId = args['daily_logbook_id'].toString();
        if (args['prefill_tail_number'] != null) {
          _prefillTailNumber = args['prefill_tail_number'].toString();
        }
      }
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

  /// Pre-select origin/destination airports in edit mode once airports are loaded
  void _tryAutoSelectAirports() {
    if (_editArgs == null || _airports.isEmpty) return;
    final origin = _editArgs!['origin_iata_code'];
    final dest = _editArgs!['destination_iata_code'];

    AirportEntity? matchByIata(dynamic iata) {
      if (iata == null) return null;
      return _airports.cast<AirportEntity?>().firstWhere(
        (a) => a!.iataCode == iata,
        orElse: () => null,
      );
    }

    final matchedOrigin = matchByIata(origin);
    final matchedDest = matchByIata(dest);
    if (matchedOrigin != null || matchedDest != null) {
      setState(() {
        _selectedOrigin ??= matchedOrigin;
        _selectedDestination ??= matchedDest;
      });
    }
  }

  /// Resolve the selected origin/destination airport pair against the
  /// already-loaded airline routes for this employee. Airline routes are
  /// preconfigured by the admin, so this only picks an existing route —
  /// it never creates one.
  ///
  /// Matches by airport ID first — unlike IATA/OACI codes, the ID is always
  /// present, so this resolves the route regardless of whether the airport
  /// was searched/selected by its IATA or its OACI code, and even for
  /// airports that only have an OACI code (no IATA). Falls back to matching
  /// by IATA code for routes fetched before the airport-ID fields existed.
  void _tryResolveRoute() {
    if (_selectedOrigin == null || _selectedDestination == null) {
      setState(() {
        _selectedRoute = null;
        _pendingRoute = null;
      });
      return;
    }
    final byId = _airlineRoutes.cast<AirlineRouteEntity?>().firstWhere(
      (r) =>
          r!.originAirportId != null &&
          r.originAirportId == _selectedOrigin!.id &&
          r.destinationAirportId == _selectedDestination!.id,
      orElse: () => null,
    );
    final match =
        byId ??
        _airlineRoutes.cast<AirlineRouteEntity?>().firstWhere(
          (r) =>
              r!.originAirportCode == _selectedOrigin!.iataCode &&
              r.destinationAirportCode == _selectedDestination!.iataCode,
          orElse: () => null,
        );

    if (match != null) {
      setState(() {
        _selectedRoute = match;
        _pendingRoute = null;
      });
      return;
    }

    // No active link for this airline yet — ask the backend to resolve it.
    // If a physical route exists for this origin/destination it'll come
    // back either already usable or freshly auto-created as "pending"; if
    // no physical route exists at all, this 404s and the UI falls back to
    // the existing "no route configured" message.
    setState(() {
      _selectedRoute = null;
      _pendingRoute = null;
      _isResolvingRoute = true;
    });
    context.read<EmployeeBloc>().add(
      ResolveAirlineRoute(
        originAirportId: _selectedOrigin!.id,
        destinationAirportId: _selectedDestination!.id,
      ),
    );
  }

  @override
  void dispose() {
    _flightController.dispose();
    _originSearchController.dispose();
    _destinationSearchController.dispose();
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
            } else if (state is AirlineRouteResolved) {
              setState(() {
                _isResolvingRoute = false;
                if (state.airlineRoute.isActive) {
                  _selectedRoute = state.airlineRoute;
                  _pendingRoute = null;
                } else {
                  // Pending (just auto-created, or already pending from a
                  // previous request) — not usable to create a flight yet.
                  _selectedRoute = null;
                  _pendingRoute = state.airlineRoute;
                }
              });
            } else if (state is EmployeeError) {
              if (_isResolvingRoute) {
                // Most commonly a 404 — no physical route configured for
                // this origin/destination at all. Falls back to the
                // existing "no route configured" message in that case.
                setState(() {
                  _isResolvingRoute = false;
                  _selectedRoute = null;
                  _pendingRoute = null;
                });
              } else {
                setState(() {
                  _isLoadingRoutes = false;
                  _errorMessage = state.message;
                });
              }
            }
          },
        ),
        BlocListener<FlightBloc, FlightState>(
          listener: (context, state) {
            if (state is LogbookIdLoaded && _logbookId == null) {
              setState(() {
                _logbookId = state.logbookId;
              });
            } else if (_isSavingWithKnownTailNumber) {
              if (state is FlightCreated) {
                setState(() => _isSavingWithKnownTailNumber = false);
                _navigateToDetailAfterCreate(state.flight);
              } else if (state is FlightError) {
                setState(() => _isSavingWithKnownTailNumber = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: const Color(0xFFe17055),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            }
          },
        ),
        BlocListener<AirportBloc, AirportState>(
          listener: (context, state) {
            if (state is AirportSuccess) {
              setState(() {
                _airports = state.airports;
                _isLoadingAirports = false;
              });
              if (_isEditMode) {
                _tryAutoSelectAirports();
              }
            } else if (state is AirportLoading) {
              setState(() => _isLoadingAirports = true);
            } else if (state is AirportError) {
              setState(() => _isLoadingAirports = false);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ResponsivePadding.maxContentWidth,
              ),
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
                      _buildOriginDestinationFields(),
                      const SizedBox(height: 16),
                      _buildRouteResolutionArea(),
                      const SizedBox(height: 32),
                      _buildContinueButton(),
                    ],
                  ),
                ),
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
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _flightController.text.trim().isNotEmpty
                ? 'Flight ${_flightController.text.trim()}'
                : (_isEditMode ? 'Edit Flight' : 'New Flight'),
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_selectedRoute != null)
            Text(
              _routeCodeLabel(_selectedRoute!),
              style: const TextStyle(color: Color(0xFF6c757d), fontSize: 13),
            ),
        ],
      ),
      centerTitle: true,
    );
  }

  /// Route code for display — prefers IATA (the system's convention) but
  /// falls back to OACI when an airport in the route has no IATA code.
  String _routeCodeLabel(AirlineRouteEntity route) {
    final origin = route.originAirportCode ?? route.originOaciCode ?? '???';
    final destination =
        route.destinationAirportCode ?? route.destinationOaciCode ?? '???';
    return '$origin → $destination';
  }

  /// Airport code for display — prefers IATA, falls back to OACI.
  String _airportCodeLabel(AirportEntity airport) {
    return airport.iataCode ?? airport.oaciCode ?? '???';
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
                      if (value == null || value.trim().isEmpty) {
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

  Widget _buildOriginDestinationFields() {
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFe0e0e0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAirportPicker(
                  hint: 'Ingrese origen',
                  controller: _originSearchController,
                  query: _originQuery,
                  selected: _selectedOrigin,
                  onChanged: (value) => setState(() => _originQuery = value),
                  onSelect: (airport) {
                    setState(() {
                      _selectedOrigin = airport;
                      _originSearchController.clear();
                      _originQuery = '';
                    });
                    _tryResolveRoute();
                  },
                  onClear: () {
                    setState(() {
                      _selectedOrigin = null;
                      _selectedRoute = null;
                      _pendingRoute = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAirportPicker(
                  hint: 'Ingrese destino',
                  controller: _destinationSearchController,
                  query: _destinationQuery,
                  selected: _selectedDestination,
                  onChanged:
                      (value) => setState(() => _destinationQuery = value),
                  onSelect: (airport) {
                    setState(() {
                      _selectedDestination = airport;
                      _destinationSearchController.clear();
                      _destinationQuery = '';
                    });
                    _tryResolveRoute();
                  },
                  onClear: () {
                    setState(() {
                      _selectedDestination = null;
                      _selectedRoute = null;
                      _pendingRoute = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAirportPicker({
    required String hint,
    required TextEditingController controller,
    required String query,
    required AirportEntity? selected,
    required ValueChanged<String> onChanged,
    required ValueChanged<AirportEntity> onSelect,
    required VoidCallback onClear,
  }) {
    if (selected != null) {
      return _buildSelectedAirportChip(selected, onClear);
    }

    final filtered =
        query.isEmpty
            ? const <AirportEntity>[]
            : _airports.where((a) {
              final q = query.toLowerCase();
              return (a.iataCode ?? '').toLowerCase().contains(q) ||
                  (a.oaciCode ?? '').toLowerCase().contains(q) ||
                  a.name.toLowerCase().contains(q) ||
                  (a.city ?? '').toLowerCase().contains(q);
            }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [_UpperCaseTextFormatter()],
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF6c757d),
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
                color: Color(0xFF6c757d),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (query.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 160),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFe0e0e0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                _isLoadingAirports
                    ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF4facfe),
                          ),
                        ),
                      ),
                    )
                    : filtered.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'No airports found',
                        style: TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 12,
                        ),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      itemBuilder:
                          (context, index) =>
                              _buildAirportListItem(filtered[index], onSelect),
                    ),
          ),
      ],
    );
  }

  Widget _buildAirportListItem(
    AirportEntity airport,
    ValueChanged<AirportEntity> onSelect,
  ) {
    return InkWell(
      onTap: () => onSelect(airport),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFe9ecef))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _airportLocationLabel(airport),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a2e),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _airportSecondaryLabel(airport),
              style: const TextStyle(fontSize: 10, color: Color(0xFF6c757d)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedAirportChip(AirportEntity airport, VoidCallback onClear) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _airportLocationLabel(airport),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1a1a2e),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _airportSecondaryLabel(airport),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6c757d),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClear,
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.close, size: 16, color: Color(0xFF6c757d)),
            ),
          ),
        ],
      ),
    );
  }

  /// "City, IATA - Country" — falls back to the airport name for whichever
  /// piece isn't populated yet (e.g. before the city/country migration ran),
  /// and to the OACI code when the airport has no IATA code at all.
  String _airportLocationLabel(AirportEntity airport) {
    final city = (airport.city ?? '').isNotEmpty ? airport.city! : airport.name;
    final code = _airportCodeLabel(airport);
    if ((airport.country ?? '').isNotEmpty) {
      return '$city, $code - ${airport.country}';
    }
    return '$city, $code';
  }

  /// Airport name plus OACI code when available, e.g. "El Dorado · OACI SKBO".
  String _airportSecondaryLabel(AirportEntity airport) {
    if ((airport.oaciCode ?? '').isNotEmpty) {
      return '${airport.name} · OACI ${airport.oaciCode}';
    }
    return airport.name;
  }

  Widget _buildRouteResolutionArea() {
    if (_isLoadingRoutes || _isLoadingAirports || _isResolvingRoute) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF4facfe)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFe17055).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFe17055), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Color(0xFFe17055), fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<EmployeeBloc>().add(LoadEmployeeAirlineRoutes());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_selectedRoute != null) {
      return Column(
        children: [
          _buildSelectedRouteCard(),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedRoute = null;
                  _pendingRoute = null;
                  _selectedOrigin = null;
                  _selectedDestination = null;
                });
              },
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Change Route'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4facfe),
              ),
            ),
          ),
        ],
      );
    }

    if (_pendingRoute != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf5a623).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.hourglass_top,
              color: Color(0xFFf5a623),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Ruta ${_routeCodeLabel(_pendingRoute!)} enviada para aprobación del administrador. Podrás usarla una vez sea aprobada.',
                style: const TextStyle(color: Color(0xFFb8770f), fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedOrigin != null && _selectedDestination != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFe17055).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFe17055), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'No hay ruta configurada para ${_airportCodeLabel(_selectedOrigin!)} → ${_airportCodeLabel(_selectedDestination!)}',
                style: const TextStyle(color: Color(0xFFe17055), fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
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
                  _routeCodeLabel(_selectedRoute!),
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
        onPressed: _isSavingWithKnownTailNumber ? null : _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isSavingWithKnownTailNumber
                ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isEditMode ? 'SAVE FLIGHT' : 'CONTINUE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isEditMode ? Icons.save : Icons.arrow_forward,
                      color: Colors.white,
                    ),
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

  Future<void> _onContinue() async {
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

      // Navigate to Tail Number lookup (Step 2)
      // POST /daily-logbooks/:id/details needs: flight_real_date, flight_number, airline_route_id
      // The backend resolves route_code, origin/destination iata, airline_code from airline_route_id
      final flightData = <String, dynamic>{
        'daily_logbook_id': _logbookId ?? '',
        'flight_real_date':
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        'flight_number': _flightController.text.trim(),
        'airline_route_id': _selectedRoute!.id,
      };

      // Forward detail_id if editing an existing flight (for PUT instead of POST)
      if (_editArgs != null && _editArgs!['detail_id'] != null) {
        flightData['detail_id'] = _editArgs!['detail_id'];
      }

      if (_isEditMode) {
        // Editing an existing flight: the tail number is fixed at the book
        // page level (captured once in "New Logbook Entry") and doesn't need
        // to be looked up/confirmed again — go straight back to Daily
        // Logbook Detail with the updated flight-level fields. Leaving
        // tail_number_id/tail_number_name out of this map means
        // DailyLogbookDetailPage keeps the flight's existing tail number.
        if (mounted) Navigator.of(context).pop(flightData);
        return;
      }

      if (_prefillTailNumber != null) {
        // The book page already has a tail number (captured once in "New
        // Logbook Entry") — save the flight directly without showing the
        // tail number screen at all. A different aircraft would mean a
        // different book page/logbook, not a per-flight override here.
        // tail_number_id is intentionally omitted: the backend fills it in
        // from the parent daily_logbook.
        setState(() => _isSavingWithKnownTailNumber = true);
        context.read<FlightBloc>().add(
          CreateFlight(
            dailyLogbookId: flightData['daily_logbook_id'] as String,
            data: {
              'flight_real_date': flightData['flight_real_date'],
              'flight_number': flightData['flight_number'],
              'airline_route_id': flightData['airline_route_id'],
            },
          ),
        );
        return;
      }

      // No tail number saved on this book page yet (e.g. an older logbook) —
      // fall back to the search/create tail number screen.
      final result = await Navigator.pushNamed(
        context,
        '/tail-number',
        arguments: flightData,
      );

      // If TailNumber returned edit data (Map), propagate back to DailyLogbookDetailPage
      if (result is Map<String, dynamic> && mounted) {
        Navigator.of(context).pop(result);
      }
    }
  }

  /// Mirrors TailNumberLookupPage._navigateToDetail: after creating the
  /// flight, replace the navigation stack with the detail form so the pilot
  /// can fill in times, pilot role, etc.
  void _navigateToDetailAfterCreate(FlightEntity? flight) {
    if (flight == null) {
      Navigator.of(context).pop();
      return;
    }

    final detail = LogbookDetailEntity(
      id: flight.id,
      dailyLogbookId: flight.dailyLogbookId,
      flightNumber: flight.flightNumber,
      flightRealDate: flight.flightRealDate,
      airlineRouteId: flight.airlineRouteId,
      routeCode: flight.routeCode,
      originIataCode: flight.originIataCode,
      destinationIataCode: flight.destinationIataCode,
      airlineCode: flight.airlineCode,
      tailNumberId: flight.tailNumberId,
      tailNumber: flight.tailNumber,
      modelName: flight.modelName,
      outTime: flight.outTime,
      takeoffTime: flight.takeoffTime,
      landingTime: flight.landingTime,
      inTime: flight.inTime,
      airTime: flight.airTime,
      blockTime: flight.blockTime,
      pilotRole: flight.pilotRole,
      companionName: flight.companionName,
      passengers: flight.passengers,
      approachCategory: flight.approachType,
      flightType: flight.flightType,
    );

    Navigator.of(context).popUntil(
      (route) => route.isFirst || route.settings.name == '/daily-logbook-detail',
    );
    Navigator.of(
      context,
    ).pushNamed('/daily-logbook-detail-form', arguments: {'detail': detail});
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
