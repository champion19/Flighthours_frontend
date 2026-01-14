import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/pages/airline_list_page.dart';
import 'package:flight_hours_app/features/airline/presentation/pages/airline_selection_page.dart';
import 'package:flight_hours_app/features/email_verification/presentation/bloc/email_verification_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/pages/change_password_page.dart';
import 'package:flight_hours_app/features/employee/presentation/pages/employee_profile_page.dart';
import 'package:flight_hours_app/features/login/presentation/pages/hello_employee_loginpage.dart';
import 'package:flight_hours_app/features/login/presentation/pages/login_page.dart';
import 'package:flight_hours_app/features/register/presentation/pages/email_info_page.dart';
import 'package:flight_hours_app/features/reset_password/presentation/pages/reset_password_page.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_bloc.dart';
import 'package:flight_hours_app/features/route/presentation/pages/flight_routes_page.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_bloc.dart';
import 'package:flight_hours_app/features/airline_route/presentation/pages/airline_routes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/authpage.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/core/services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InjectorApp.setyp();

  // Initialize session service to restore any persisted tokens
  await SessionService().init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => AirlineBloc()),
        BlocProvider(create: (_) => EmailVerificationBloc()),
        BlocProvider(create: (_) => EmployeeBloc()),
        BlocProvider(create: (_) => RouteBloc()),
        BlocProvider(create: (_) => AirlineRouteBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        title: 'Flight Hours',
        routes: {
          '/home': (context) => const HelloEmployee(),
          '/login': (context) => const LoginPage(),
          '/airlines': (context) => const AirlineListPage(),
          '/airline-selection': (context) => const AirlineSelectionPage(),
          '/email': (context) => const VerificationPage(email: ''),
          '/reset-password': (context) => const ResetPasswordPage(),
          '/employee-profile': (context) => const EmployeeProfilePage(),
          '/change-password': (context) => const ChangePasswordPage(),
          '/flight-routes': (context) => const FlightRoutesPage(),
          '/airline-routes': (context) => const AirlineRoutesPage(),
        },
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    ),
  );
}
