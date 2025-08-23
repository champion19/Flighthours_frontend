import 'package:flight_hours_app/core/validator/form_validator.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback? onSwitchToRegister;

  const LoginPage({super.key, this.onSwitchToRegister});

  void _handleLoginSuccess(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error de login"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginSuccess) {
            _handleLoginSuccess(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: LoginForm(
                  onSubmit: (email, password) {
                    // Corregido: FormValidator en lugar de FormValidators
                    final emailError = FormValidator.validateEmail(email);
                    final passwordError = FormValidator.validatePassword(password);

                    if (emailError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(emailError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(passwordError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    context.read<LoginBloc>().add(
                      LoginSubmitted(email: email, password: password),
                    );
                  },
                ),
              ),
              if (onSwitchToRegister != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: onSwitchToRegister,
                        child: const Text(
                          "Sign up",
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
          ),
        ),
      ),
    );
  }
}
