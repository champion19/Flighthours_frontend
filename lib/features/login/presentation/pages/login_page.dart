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

  void _showEmailNotVerifiedDialog(BuildContext context, String message) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.orange[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Email Not Verified',
                style: TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4facfe),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
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
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginEmailNotVerified) {
              _showEmailNotVerifiedDialog(context, state.message);
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Login successful! Welcome to FlightHours.',
                  ),
                  backgroundColor: const Color(0xFF4facfe),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              _handleLoginSuccess(context);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Logo con gradiente cyan
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4facfe).withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Título
                  const Text(
                    'Flight Hours',
                    style: TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  // Formulario de login
                  LoginForm(
                    onSubmit: (email, password) {
                      // Validate email and password
                      final emailError = FormValidator.validateEmail(email);
                      final passwordError = FormValidator.validatePassword(
                        password,
                      );

                      if (emailError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(emailError),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        return;
                      }

                      if (passwordError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(passwordError),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        return;
                      }

                      context.read<LoginBloc>().add(
                        LoginSubmitted(email: email, password: password),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (onSwitchToRegister != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Color(0xFF6c757d),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: onSwitchToRegister,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF4facfe),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 14,
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
        ),
      ),
    );
  }
}
