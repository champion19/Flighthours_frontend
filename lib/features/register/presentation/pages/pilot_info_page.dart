import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Pilotinfo extends StatefulWidget {
  const Pilotinfo({super.key, this.onSwitchToLogin, this.pageController});
  final VoidCallback? onSwitchToLogin;
  final PageController? pageController;

  @override
  State<Pilotinfo> createState() => PilotinfoState();
}

class PilotinfoState extends State<Pilotinfo> {
  @override
  void initState() {
    super.initState();
    context.read<AirlineBloc>().add(FetchAirlines());
  }

  final _formKey = GlobalKey<FormState>();
  final _bpController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  String? _selectedAirlineId; // Store the airline ID (obfuscated)
  bool _vigente = false;

  @override
  void dispose() {
    _bpController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, EmployeeEntityRegister currentEmployee) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the complete employee with all data
      // The form validators already ensure BP, dates, and airline are filled
      final completeEmployee = currentEmployee.copyWith(
        bp: _bpController.text.trim(),
        fechaInicio: _fechaInicioController.text,
        fechaFin: _fechaFinController.text,
        vigente: _vigente,
        airline: _selectedAirlineId,
      );

      // Dispatch the complete registration flow
      context.read<RegisterBloc>().add(
        CompleteRegistrationFlow(employee: completeEmployee),
      );
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6c757d)),
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
      prefixIcon: Icon(icon, color: const Color(0xFF4facfe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        EmployeeEntityRegister? currentEmployee;
        if (state is PersonalInfoCompleted) {
          currentEmployee = state.employee;
        }

        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Pilot Information",
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your pilot details",
              style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _bpController,
                        style: const TextStyle(color: Color(0xFF1a1a2e)),
                        decoration: _buildInputDecoration(
                          label: 'BP Code',
                          icon: Icons.numbers_outlined,
                        ),
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'BP code is required';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _fechaInicioController,
                        style: const TextStyle(color: Color(0xFF1a1a2e)),
                        decoration: _buildInputDecoration(
                          label: 'Start Date',
                          icon: Icons.calendar_today,
                        ),
                        readOnly: true,
                        onTap:
                            () => _selectDate(context, _fechaInicioController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Start date is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _fechaFinController,
                        style: const TextStyle(color: Color(0xFF1a1a2e)),
                        decoration: _buildInputDecoration(
                          label: 'End Date',
                          icon: Icons.event_outlined,
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _fechaFinController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'End date is required';
                          }
                          if (_fechaInicioController.text.isNotEmpty) {
                            final startDate = DateFormat(
                              'yyyy-MM-dd',
                            ).parse(_fechaInicioController.text);
                            final endDate = DateFormat(
                              'yyyy-MM-dd',
                            ).parse(value);
                            if (endDate.isBefore(startDate)) {
                              return 'End date cannot be before start date';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFf8f9fa),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF212529)),
                        ),
                        child: CheckboxListTile(
                          title: const Text(
                            'Active',
                            style: TextStyle(color: Color(0xFF1a1a2e)),
                          ),
                          value: _vigente,
                          activeColor: const Color(0xFF4facfe),
                          onChanged: (bool? value) {
                            setState(() {
                              _vigente = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      BlocBuilder<AirlineBloc, AirlineState>(
                        builder: (context, state) {
                          if (state is AirlineLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF4facfe),
                              ),
                            );
                          } else if (state is AirlineSuccess) {
                            return DropdownButtonFormField<String>(
                              decoration: _buildInputDecoration(
                                label: 'Airline',
                                icon: Icons.flight,
                              ),
                              dropdownColor: Colors.white,
                              style: const TextStyle(color: Color(0xFF1a1a2e)),
                              value: _selectedAirlineId,
                              hint: const Text(
                                'Select Airline',
                                style: TextStyle(color: Color(0xFF6c757d)),
                              ),
                              items:
                                  state.airlines.map((airline) {
                                    return DropdownMenuItem<String>(
                                      value: airline.id, // Use ID as value
                                      child: Text(airline.name),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedAirlineId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an airline';
                                }
                                return null;
                              },
                            );
                          } else if (state is AirlineError) {
                            return Text(
                              state.message,
                              style: const TextStyle(color: Colors.redAccent),
                            );
                          } else {
                            return const Text(
                              'No airlines found',
                              style: TextStyle(color: Color(0xFF6c757d)),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              isLoading || currentEmployee == null
                                  ? null
                                  : () => _submit(context, currentEmployee!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4facfe),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.onSwitchToLogin != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16, color: Color(0xFF6c757d)),
                    ),
                    TextButton(
                      onPressed: widget.onSwitchToLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4facfe),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
