import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  const LoginForm({super.key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_email, _password);
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF4facfe), size: 22),
      filled: true,
      fillColor: const Color(0xFFf8f9fa),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF212529), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4facfe), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: _buildInputDecoration(
              label: 'Email',
              icon: Icons.email_outlined,
            ),
            style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!.trim(),
            validator: (value) => value!.isEmpty ? 'Email is required' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: _buildInputDecoration(
              label: 'Password',
              icon: Icons.lock_outline,
            ),
            style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
            obscureText: true,
            onSaved: (value) => _password = value!,
            validator:
                (value) =>
                    value!.isEmpty
                        ? 'Password must be at least 6 characters'
                        : null,
          ),
          const SizedBox(height: 16),
          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reset-password');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4facfe),
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const SizedBox(
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4facfe),
                      strokeWidth: 3,
                    ),
                  ),
                );
              }
              return LoginEnter(text: 'Login', onPressed: _submit);
            },
          ),
        ],
      ),
    );
  }
}
