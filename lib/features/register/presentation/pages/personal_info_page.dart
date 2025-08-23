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
        const Text("Información personal"),
        Expanded( 
          child: RegisterForm(pageController: pageController),
        ),
        if (onSwitchToLogin != null)
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
                  onPressed: onSwitchToLogin,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

