import 'package:flight_hours_app/core/services/session_service.dart';
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
  late TextEditingController _airlineController;
  late TextEditingController _identificationController;
  late TextEditingController _bpController;
  late TextEditingController _roleController;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  // Original data for airline ID
  String? _airlineId;
  EmployeeData? _currentData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _airlineController = TextEditingController();
    _identificationController = TextEditingController();
    _bpController = TextEditingController();
    _roleController = TextEditingController();

    // Load current employee data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeBloc>().add(LoadCurrentEmployee());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _airlineController.dispose();
    _identificationController.dispose();
    _bpController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _populateForm(EmployeeData data) {
    _currentData = data;
    _nameController.text = data.name;
    _airlineId = data.airline;
    _airlineController.text = data.airline ?? '';
    _identificationController.text = data.identificationNumber ?? '';
    _bpController.text = data.bp ?? '';
    _roleController.text = data.role ?? '';
    _startDate = data.startDate;
    _endDate = data.endDate;
    _isActive = data.active;
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
      role: _roleController.text.trim().toLowerCase(),
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
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF667eea),
              onPrimary: Colors.white,
              surface: Color(0xFF1a1a2e),
              onSurface: Colors.white,
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
          backgroundColor: const Color(0xFF1a1a2e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.redAccent, width: 1),
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
                  color: Colors.white,
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your data will be permanently removed from the system.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<EmployeeBloc, EmployeeState>(
            listener: (context, state) async {
              if (state is EmployeeDetailSuccess) {
                _populateForm(state.response.data!);
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
                // Reload the data
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
    );
  }

  Widget _buildHeader(EmployeeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View and edit your information',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          if (state is EmployeeDetailSuccess && !_isEditing)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF667eea)),
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
        child: CircularProgressIndicator(color: Color(0xFF667eea)),
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
                backgroundColor: const Color(0xFF667eea),
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
                style: TextStyle(color: Colors.white70, fontSize: 14),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea).withValues(alpha: 0.3),
            const Color(0xFF764ba2).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF667eea).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
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
                      color: Colors.white,
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
                        color: const Color(0xFF667eea).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _roleController.text.isNotEmpty
                            ? _roleController.text.toUpperCase()
                            : 'N/A',
                        style: const TextStyle(
                          color: Color(0xFF667eea),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Information'),
          const SizedBox(height: 20),
          if (_isEditing) ...[
            _buildTextField(
              controller: _roleController,
              label: 'Role',
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 16),
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
            _buildTextField(
              controller: _airlineController,
              label: 'Airline ID',
              icon: Icons.flight,
              onChanged: (value) {
                _airlineId = value;
              },
            ),
          ] else ...[
            _buildInfoRow(
              'Role',
              _roleController.text.isNotEmpty
                  ? _roleController.text.toUpperCase()
                  : 'Not specified',
              Icons.work_outline,
            ),
            const Divider(color: Colors.white12, height: 24),
            _buildInfoRow(
              'Identification',
              _identificationController.text.isNotEmpty
                  ? _identificationController.text
                  : 'Not specified',
              Icons.credit_card_outlined,
            ),
            const Divider(color: Colors.white12, height: 24),
            _buildInfoRow(
              'BP Number',
              _bpController.text.isNotEmpty
                  ? _bpController.text
                  : 'Not specified',
              Icons.numbers_outlined,
            ),
            const Divider(color: Colors.white12, height: 24),
            _buildInfoRow(
              'Airline',
              _airlineController.text.isNotEmpty
                  ? _airlineController.text
                  : 'Not specified',
              Icons.flight,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Contract Period'),
          const SizedBox(height: 20),
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
            const Divider(color: Colors.white12, height: 24),
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
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(
              isStartDate
                  ? Icons.calendar_today_outlined
                  : Icons.event_outlined,
              color: const Color(0xFF667eea),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_calendar, color: Colors.white38, size: 20),
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
            color: const Color(0xFF667eea),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF667eea), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
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
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
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
                  backgroundColor: const Color(0xFF667eea),
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
