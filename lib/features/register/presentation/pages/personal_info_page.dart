import 'package:flight_hours_app/features/register/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';

class Personalinfo extends StatelessWidget {
  final VoidCallback? onSwitchToLogin;
  final PageController pageController;

  const Personalinfo({
    super.key,
    this.onSwitchToLogin,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Personal Information",
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Enter your basic details",
          style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
        ),
        const SizedBox(height: 20),
        Expanded(child: RegisterForm(pageController: pageController)),
        if (onSwitchToLogin != null)
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
                  onPressed: onSwitchToLogin,
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
  }
}
