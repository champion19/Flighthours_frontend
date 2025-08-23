import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/presentation/pages/email_info_page.dart';
import 'package:flight_hours_app/features/register/presentation/pages/personal_info_page.dart';
import 'package:flight_hours_app/features/register/presentation/pages/pilot_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;

  const RegisterPage({super.key, this.onSwitchToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  PageController pageController = PageController(initialPage: 0);

  void _handleRegisterSuccess(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      if (widget.onSwitchToLogin != null) {
        widget.onSwitchToLogin!();
      }
    });
  }

  void _navigateToNextPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro'), centerTitle: true),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is PersonalInfoCompleted) {
            _navigateToNextPage();
          } else if (state is PilotInfoCompleted) {
            _navigateToNextPage();
          } else if (state is RegisterSuccess) {
            _handleRegisterSuccess(context);
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Personalinfo(
              onSwitchToLogin: widget.onSwitchToLogin,
              pageController: pageController,
            ),
            Pilotinfo(
              pageController: pageController,
              onSwitchToLogin: widget.onSwitchToLogin,
            ),
            VerificationPage(email: "",),

          ],
        ),
      ),
    );
  }
}
