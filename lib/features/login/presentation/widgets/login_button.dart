import 'package:flutter/material.dart';

class LoginEnter extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LoginEnter({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.blueAccent),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
        ),
      ),
    );
  }
}
