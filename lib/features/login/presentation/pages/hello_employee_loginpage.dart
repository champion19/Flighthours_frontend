
import 'package:flutter/material.dart';

class HelloEmployee extends StatelessWidget {
  const HelloEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hey Employee')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/airport');
          },
          child: const Text('Go to Airport Info'),
        ),
      ),
    );
  }
}
