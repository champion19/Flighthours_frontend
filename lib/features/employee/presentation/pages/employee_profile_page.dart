import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flight_hours_app/features/airline/presentation/pages/airline_selection_page.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({super.key});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _identificationController;
  late TextEditingController _bpController;
  // Role is always 'pilot' - no controller needed
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  // Airline data
  String? _airlineId;
  AirlineEntity? _selectedAirline;
  List<AirlineEntity> _airlines = [];
  EmployeeData? _currentData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _identificationController = TextEditingController();
    _bpController = TextEditingController();
    // Role is fixed to 'pilot'

    // Load current employee data only
    // GET /airlines/:id will be called after employee loads (if airline exists)
    // GET /airlines will only be called when user opens AirlineSelectionPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeBloc>().add(LoadCurrentEmployee());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identificationController.dispose();
    _bpController.dispose();
    // No role controller to dispose
    super.dispose();
  }

  void _populateForm(EmployeeData data) {
    _currentData = data;
    _nameController.text = data.name;
    _airlineId = data.airline;
    _identificationController.text = data.identificationNumber ?? '';
    _bpController.text = data.bp ?? '';
    // Try to find the airline in local list (if available)
    _updateSelectedAirline();
    // Role is always 'pilot'
    _startDate = data.startDate;
    _endDate = data.endDate;
    _isActive = data.active;
  }

  void _updateSelectedAirline() {
    if (_airlineId != null && _airlines.isNotEmpty) {
      // Try to find by obfuscated id OR by uuid (from database)
      _selectedAirline = _airlines.firstWhere(
        (a) => a.id == _airlineId || a.uuid == _airlineId,
        orElse: () => AirlineEntity(id: _airlineId!, name: _airlineId!),
      );
    }
  }

  String _getAirlineDisplayName() {
    if (_selectedAirline != null) {
      return _selectedAirline!.name;
    }
    if (_airlineId != null && _airlineId!.isNotEmpty) {
      return _airlineId!; // Fallback to show ID if airline not found
    }
    return 'Select an airline';
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    if (_currentData != null) {
      _populateForm(_currentData!);
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = EmployeeUpdateRequest(
      name: _nameController.text.trim(),
      airline: _airlineId ?? '',
      identificationNumber: _identificationController.text.trim(),
      bp: _bpController.text.trim(),
      startDate:
          _startDate != null
              ? DateFormat('yyyy-MM-dd').format(_startDate!)
              : '',
      endDate:
          _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '',
      active: _isActive,
      role: 'pilot', // Fixed role for all employees
    );

    context.read<EmployeeBloc>().add(UpdateEmployee(request: request));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate =
        isStartDate
            ? (_startDate ?? DateTime.now())
            : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Account',
                style: TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your data will be permanently removed from the system.',
                style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF6c757d)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<EmployeeBloc>().add(DeleteEmployee());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: BlocListener<AirlineBloc, AirlineState>(
            listener: (context, airlineState) {
              if (airlineState is AirlineSuccess) {
                setState(() {
                  _airlines = airlineState.airlines;
                  _updateSelectedAirline();
                });
              } else if (airlineState is AirlineDetailSuccess) {
                // Got airline details by ID
                setState(() {
                  _selectedAirline = airlineState.airline;
                });
              }
            },
            child: BlocConsumer<EmployeeBloc, EmployeeState>(
              listener: (context, state) async {
                if (state is EmployeeDetailSuccess) {
                  _populateForm(state.response.data!);
                  // After loading employee data, fetch airline name if needed
                  final airlineId = state.response.data!.airline;
                  if (airlineId != null && airlineId.isNotEmpty) {
                    // Fetch airline by ID to get the name
                    context.read<AirlineBloc>().add(
                      FetchAirlineById(airlineId: airlineId),
                    );
                  }
                } else if (state is EmployeeUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.response.message),
                      backgroundColor: const Color(0xFF00b894),
                    ),
                  );
                  setState(() {
                    _isEditing = false;
                  });
                  // Reload the data - this will trigger EmployeeDetailSuccess
                  // which will then call FetchAirlineById to get the airline name
                  context.read<EmployeeBloc>().add(LoadCurrentEmployee());
                } else if (state is EmployeeDeleteSuccess) {
                  // Clear session and navigate to login
                  await SessionService().clearSession();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.response.message),
                        backgroundColor: const Color(0xFF00b894),
                      ),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  }
                } else if (state is EmployeeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    _buildHeader(state),
                    Expanded(child: _buildContent(state)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(EmployeeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4facfe).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF4facfe),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Profile',
                  style: TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View and edit your information',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
                ),
              ],
            ),
          ),
          if (state is EmployeeDetailSuccess && !_isEditing)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF4facfe)),
                onPressed: _toggleEdit,
                tooltip: 'Edit Profile',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(EmployeeState state) {
    if (state is EmployeeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4facfe)),
      );
    }

    if (state is EmployeeError && _currentData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<EmployeeBloc>().add(LoadCurrentEmployee());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4facfe),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildDatesCard(),
            if (_isEditing) ...[
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
            const SizedBox(height: 32),
            _buildDangerZone(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        final isDeleting = state is EmployeeDeleting;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Danger Zone',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Once you delete your account, there is no going back. Please be certain.',
                style: TextStyle(color: Color(0xFF666666), fontSize: 14),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isDeleting ? null : _showDeleteConfirmation,
                  icon:
                      isDeleting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Icons.delete_forever),
                  label: Text(isDeleting ? 'Deleting...' : 'Delete Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF212529), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing)
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  )
                else
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : 'Loading...',
                    style: const TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            color: Color(0xFF4facfe),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PILOT',
                            style: TextStyle(
                              color: Color(0xFF4facfe),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _isActive
                                ? const Color(0xFF00b894).withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color:
                                  _isActive
                                      ? const Color(0xFF00b894)
                                      : Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color:
                                  _isActive
                                      ? const Color(0xFF00b894)
                                      : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF212529), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing) ...[
            _buildTextField(
              controller: _identificationController,
              label: 'Identification Number',
              icon: Icons.credit_card_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bpController,
              label: 'BP Number',
              icon: Icons.numbers_outlined,
            ),
            const SizedBox(height: 16),
            _buildAirlineDropdown(),
          ] else ...[
            _buildInfoRow(
              'Identification',
              _identificationController.text.isNotEmpty
                  ? _identificationController.text
                  : 'Not specified',
              Icons.credit_card_outlined,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'BP Number',
              _bpController.text.isNotEmpty
                  ? _bpController.text
                  : 'Not specified',
              Icons.numbers_outlined,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Airline', _getAirlineDisplayName(), Icons.flight),
          ],
        ],
      ),
    );
  }

  Widget _buildDatesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF212529), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing) ...[
            _buildDatePicker('Start Date', _startDate, true),
            const SizedBox(height: 16),
            _buildDatePicker('End Date', _endDate, false),
          ] else ...[
            _buildInfoRow(
              'Start Date',
              _formatDate(_startDate),
              Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'End Date',
              _formatDate(_endDate),
              Icons.event_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF212529)),
        ),
        child: Row(
          children: [
            Icon(
              isStartDate
                  ? Icons.calendar_today_outlined
                  : Icons.event_outlined,
              color: const Color(0xFF4facfe),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF6c757d),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: const TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_calendar, color: Color(0xFF4facfe), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF4facfe),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6c757d),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFf8f9fa),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF212529)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF4facfe), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF1a1a2e)),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF6c757d)),
        prefixIcon: Icon(icon, color: const Color(0xFF4facfe)),
        filled: true,
        fillColor: const Color(0xFFf8f9fa),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF212529)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4facfe), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildAirlineDropdown() {
    return GestureDetector(
      onTap: _openAirlineSelection,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF212529)),
        ),
        child: Row(
          children: [
            const Icon(Icons.flight, color: Color(0xFF4facfe)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Airline',
                    style: TextStyle(color: Color(0xFF6c757d), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAirlineDisplayName(),
                    style: TextStyle(
                      color:
                          _selectedAirline != null
                              ? const Color(0xFF1a1a2e)
                              : const Color(0xFF6c757d),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF4facfe),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAirlineSelection() async {
    final result = await Navigator.push<AirlineEntity>(
      context,
      MaterialPageRoute(
        builder:
            (context) => AirlineSelectionPage(currentAirlineId: _airlineId),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedAirline = result;
        _airlineId = result.id;
        // Update the airlines list if not already there
        if (!_airlines.any((a) => a.id == result.id)) {
          _airlines.add(result);
        }
      });
    }
  }

  Widget _buildActionButtons() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        final isUpdating = state is EmployeeUpdating;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isUpdating ? null : _cancelEdit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isUpdating ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4facfe),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child:
                    isUpdating
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}
