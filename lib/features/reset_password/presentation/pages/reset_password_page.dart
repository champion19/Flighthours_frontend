import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/reset_password/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Email Sent', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Icon(Icons.mark_email_read, size: 60, color: Colors.blue[400]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Return to login page
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: Builder(
        builder:
            (blocContext) => Scaffold(
              appBar: AppBar(
                title: const Text('Reset Password'),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccess) {
                    _showSuccessDialog(context, state.result.message);
                  } else if (state is ResetPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ResetPasswordForm(
                    onSubmit: (email) {
                      blocContext.read<ResetPasswordBloc>().add(
                        ResetPasswordSubmitted(email: email),
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
