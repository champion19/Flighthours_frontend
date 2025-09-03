import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/pages/airline_list_page.dart';
import 'package:flight_hours_app/features/login/presentation/pages/hello_employee_loginpage.dart';
import 'package:flight_hours_app/features/login/presentation/pages/login_page.dart';
import 'package:flight_hours_app/features/register/presentation/pages/email_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/authpage.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';

void main() {
  InjectorApp.setyp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => AirlineBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        title: 'Flight Hours',
        routes: {
          '/home': (context) => const HelloEmployee(),
          '/login': (context) => const LoginPage(),
          '/airlines': (context) => const AirlineListPage(),
          '/email': (context) => const VerificationPage(email: ''),
        },
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    ),
  );
}
