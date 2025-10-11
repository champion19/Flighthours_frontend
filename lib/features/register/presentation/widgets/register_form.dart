import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/presentation/pages/email_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/validators/validators.dart';

class RegisterForm extends StatefulWidget {
  final PageController pageController;

  const RegisterForm({
    super.key,
    required this.pageController,
    VoidCallback? onSwitchToLogin,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  late final BaseValidator _identityValidator = ValidatorUtils.identity();
  late final BaseValidator _nameValidator = ValidatorUtils.name();
  late final BaseValidator _emailValidator = ValidatorUtils.email();
  late final BaseValidator _passwordValidator = ValidatorUtils.password();

  BaseValidator get _confirmPasswordValidator =>
      ValidatorUtils.confirmPassword(_passwordController.text);

  String? _validateIdentity(String? value) =>
      _identityValidator.validate(value);
  String? _validateName(String? value) => _nameValidator.validate(value);
  String? _validateEmail(String? value) => _emailValidator.validate(value);
  String? _validatePassword(String? value) =>
      _passwordValidator.validate(value);
  String? _validateConfirmPassword(String? value) =>
      _confirmPasswordValidator.validate(value);

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _formKey.currentState!.save();

      BlocProvider.of<RegisterBloc>(
        (context),
      ).add(StartVerification(_emailController.text.trim()));

      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          employment: EmployeeEntityRegister(
            id: "0",
            password: _passwordController.text.trim(),
            fechaFin: DateTime.now().toIso8601String(),
            fechaInicio:
                DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
            email: _emailController.text.trim(),
            name: _nameController.text.trim(),
            idNumber: _idNumberController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }

          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro exitoso'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<RegisterBloc>(),
                      child: VerificationPage(
                        email: _emailController.text.trim(),
                      ),
                    ),
              ),
            );
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(
                  labelText: 'Numero de identificacion',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                keyboardType: TextInputType.number,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                validator: _validateIdentity,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                enabled: !isLoading,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                enabled: !isLoading,
                validator: _validateConfirmPassword,
              ),
              //const SizedBox(height: 290),
              const Spacer(),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
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
    );
  }
}
