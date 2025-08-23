import 'package:flight_hours_app/core/authpage.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    InjectorApp.setyp();
  });

  testWidgets('Initial page is the login page', (WidgetTester tester) async {
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

    expect(find.descendant(
      of: find.byType(AppBar),
      matching: find.text('Login'),
    ), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}