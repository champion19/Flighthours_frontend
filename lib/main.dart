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
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/pages/logbook_page.dart';
import 'package:flight_hours_app/features/logbook/presentation/pages/new_flight_page.dart';
import 'package:flight_hours_app/features/admin/presentation/pages/admin_home_page.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/pages/airport_list_page.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/pages/manufacturer_list_page.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_bloc.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/pages/aircraft_model_list_page.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_bloc.dart';
import 'package:flight_hours_app/features/license_plate/presentation/pages/license_plate_lookup_page.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/pages/aircraft_families_page.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_bloc.dart';
import 'package:flight_hours_app/features/daily_logbook_detail/presentation/pages/daily_logbook_detail_page.dart';
import 'package:flight_hours_app/features/daily_logbook_detail/presentation/pages/flight_records_list_page.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/pages/crew_member_type_list_page.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/authpage.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/core/services/session_service.dart';

/// Global navigator key — enables navigation from anywhere (e.g. Dio interceptor on 401)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InjectorApp.setyp();

  // Initialize session service to restore any persisted tokens
  await SessionService().init();

  // Wire DioClient to redirect to login when token expires and refresh fails
  DioClient().onForceLogout = () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false, // Clear the entire navigation stack
    );
  };

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
        BlocProvider(create: (_) => LogbookBloc()),
        BlocProvider(create: (_) => AirportBloc()),
        BlocProvider(create: (_) => ManufacturerBloc()),
        BlocProvider(create: (_) => AircraftModelBloc()),
        BlocProvider(create: (_) => LicensePlateBloc()),
        BlocProvider(create: (_) => FlightBloc()),
        BlocProvider(create: (_) => CrewMemberTypeBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          '/logbook': (context) => const LogbookPage(),
          '/new-flight': (context) => const NewFlightPage(),
          '/admin-home': (context) => const AdminHomePage(),
          '/airports': (context) => const AirportListPage(),
          '/manufacturers': (context) => const ManufacturerListPage(),
          '/aircraft-models': (context) => const AircraftModelListPage(),
          '/aircraft-families': (context) => const AircraftFamiliesPage(),
          '/license-plate': (context) => const LicensePlateLookupPage(),
          '/crew-member-types': (context) => const CrewMemberTypeListPage(),
          '/daily-logbook-detail': (context) => const FlightRecordsListPage(),
          '/daily-logbook-detail-form':
              (context) => const DailyLogbookDetailPage(),
        },
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    ),
  );
}
