import 'package:flutter/material.dart';
import 'package:flight_hours_app/features/login/presentation/pages/login_page.dart';
import 'package:flight_hours_app/features/register/presentation/pages/register_page.dart';

enum AuthPageState { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthPageState _state = AuthPageState.login;

  void _switchToRegister() {
    setState(() {
      _state = AuthPageState.login;
    });
  }

  void _switchToLogin() {
    setState(() {
      _state = AuthPageState.register;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case AuthPageState.login:
        return LoginPage(onSwitchToRegister: _switchToLogin);
      case AuthPageState.register:
        return RegisterPage(onSwitchToLogin: _switchToRegister);
    }
  }
}
