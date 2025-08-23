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
  String? _selectedAirline;
  bool _vigente = false;

  final List<String> opciones = ['Opción 1', 'Opción 2', 'Opción 3'];

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
      context.read<RegisterBloc>().add(
        EnterPilotInformation(
          employment: currentEmployee.copyWith(
            bp: int.tryParse(_bpController.text) ?? 0,
            fechaInicio: _fechaInicioController.text,
            fechaFin: _fechaFinController.text,
            vigente: _vigente ? 'si' : 'no',
            airline: _selectedAirline,
          ),
        ),
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
            Text("Información del piloto"),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _bpController,
                      decoration: const InputDecoration(
                        labelText: 'Codigo BP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El código BP es requerido';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _fechaInicioController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha inicio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _fechaInicioController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La fecha de inicio es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _fechaFinController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha fin',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _fechaFinController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La fecha de fin es requerida';
                        }
                        if (_fechaInicioController.text.isNotEmpty) {
                          final startDate = DateFormat(
                            'yyyy-MM-dd',
                          ).parse(_fechaInicioController.text);
                          final endDate = DateFormat('yyyy-MM-dd').parse(value);
                          if (endDate.isBefore(startDate)) {
                            return 'La fecha de fin no puede ser anterior a la de inicio';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CheckboxListTile(
                      title: const Text('Vigente'),
                      value: _vigente,
                      onChanged: (bool? value) {
                        setState(() {
                          _vigente = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 10.0),
                    BlocBuilder<AirlineBloc, AirlineState>(
                      builder: (context, state) {
                        if (state is AirlineLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AirlineSuccess) {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Aerolinea',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            value: _selectedAirline,
                            hint: const Text('Seleccione la Aerolinea'),
                            items:
                                state.airlines.map((airline) {
                                  return DropdownMenuItem<String>(
                                    value: airline.name,
                                    child: Text(airline.name),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedAirline = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor seleccione una aerolinea';
                              }
                              return null;
                            },
                          );
                        } else if (state is AirlineError) {
                          return Text(state.message);
                        } else {
                          return const Text('No se encontraron aerolineas');
                        }
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading || currentEmployee == null
                                ? null
                                : () => _submit(context, currentEmployee!),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                                  'Continuar',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ],
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
                      "Ya tienes una cuenta?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: widget.onSwitchToLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
