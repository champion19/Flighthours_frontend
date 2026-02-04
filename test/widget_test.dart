import 'package:flight_hours_app/core/authpage.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    // Initialize injector only once for all tests
    InjectorApp.setyp();
  });

  testWidgets('Initial page shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LoginBloc()),
            BlocProvider(create: (_) => RegisterBloc()),
          ],
          child: const AuthPage(),
        ),
      ),
    );

    // Wait for widget to build
    await tester.pump();

    // Check for sign in text
    expect(find.text('Sign in to your account'), findsOneWidget);

    // Check for "Sign up" link
    expect(find.text('Sign up'), findsOneWidget);

    // Check for "Don't have an account?" text
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

  testWidgets('AuthPage starts in login state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LoginBloc()),
            BlocProvider(create: (_) => RegisterBloc()),
          ],
          child: const AuthPage(),
        ),
      ),
    );

    await tester.pump();

    // Login page should be visible (has "Sign in to your account")
    expect(find.text('Sign in to your account'), findsOneWidget);
  });
}
