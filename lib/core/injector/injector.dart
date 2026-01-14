import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/email_verification/data/datasource/email_verifcation_datasource.dart';
import 'package:flight_hours_app/features/email_verification/data/repositories/email_verification_repository_impl.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';
import 'package:flight_hours_app/features/email_verification/domain/usecases/email_verification_use_case.dart';
import 'package:flight_hours_app/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/change_password_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';
import 'package:flight_hours_app/features/register/data/datasources/register_datasource.dart';
import 'package:flight_hours_app/features/register/data/repositories/register_repository_impl.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';
import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/repositories/airline_repository_impl.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/repositories/airport_repository_impl.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/register/domain/usecases/register_use_case.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';
import 'package:flight_hours_app/features/route/data/datasources/route_remote_data_source.dart';
import 'package:flight_hours_app/features/route/data/repositories/route_repository_impl.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/data/repositories/airline_route_repository_impl.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/list_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/get_airline_route_by_id_use_case.dart';
import 'package:kiwi/kiwi.dart';

import '../../features/login/data/repositories/login_repository_impl.dart';

part 'injector.g.dart';

abstract class InjectorApp {
  static KiwiContainer container = KiwiContainer();
  static void setyp() {
    // Register Dio singleton first - required by all datasources
    container.registerSingleton<Dio>((c) => DioClient().client);

    var injector = _$InjectorApp();
    injector._configure();
  }

  static final resolve = container.resolve;

  void _configure() {
    _configureAuthsModule();
  }

  void _configureAuthsModule() {
    _configureAuthFactories();
  }

  // Auth and Registration
  @Register.factory(LoginRepository, from: LoginRepositoryImpl)
  @Register.factory(LoginUseCase)
  @Register.factory(LoginDatasource)
  @Register.factory(RegisterRepository, from: RegisterRepositoryImpl)
  @Register.factory(RegisterUseCase)
  @Register.factory(RegisterDatasource)
  // Airline
  @Register.factory(ListAirlineUseCase)
  @Register.factory(GetAirlineByIdUseCase)
  @Register.factory(ActivateAirlineUseCase)
  @Register.factory(DeactivateAirlineUseCase)
  @Register.factory(AirlineRepository, from: AirlineRepositoryImpl)
  @Register.factory(AirlineRemoteDataSource, from: AirlineRemoteDataSourceImpl)
  // Airport
  @Register.factory(ListAirportUseCase)
  @Register.factory(GetAirportByIdUseCase)
  @Register.factory(ActivateAirportUseCase)
  @Register.factory(DeactivateAirportUseCase)
  @Register.factory(AirportRepository, from: AirportRepositoryImpl)
  @Register.factory(AirportRemoteDataSource, from: AirportRemoteDataSourceImpl)
  // Email Verification
  @Register.factory(
    EmailVerificationRepository,
    from: EmailVerificationRepositoryImpl,
  )
  @Register.factory(EmailVerificationUseCase)
  @Register.factory(EmailVerificationDatasource)
  // Reset Password
  @Register.factory(ResetPasswordRepository, from: ResetPasswordRepositoryImpl)
  @Register.factory(ResetPasswordUseCase)
  @Register.factory(ResetPasswordDatasource)
  // Employee
  @Register.factory(EmployeeRepository, from: EmployeeRepositoryImpl)
  @Register.factory(
    EmployeeRemoteDataSource,
    from: EmployeeRemoteDataSourceImpl,
  )
  @Register.factory(GetEmployeeUseCase)
  @Register.factory(UpdateEmployeeUseCase)
  @Register.factory(ChangePasswordUseCase)
  @Register.factory(DeleteEmployeeUseCase)
  // Route
  @Register.factory(ListRoutesUseCase)
  @Register.factory(GetRouteByIdUseCase)
  @Register.factory(RouteRepository, from: RouteRepositoryImpl)
  @Register.factory(RouteRemoteDataSource, from: RouteRemoteDataSourceImpl)
  // Airline Route
  @Register.factory(ListAirlineRoutesUseCase)
  @Register.factory(GetAirlineRouteByIdUseCase)
  @Register.factory(AirlineRouteRepository, from: AirlineRouteRepositoryImpl)
  @Register.factory(
    AirlineRouteRemoteDataSource,
    from: AirlineRouteRemoteDataSourceImpl,
  )
  void _configureAuthFactories();
  // comando para crear el archivo que genera el paquete injector: flutter pub run build_runner build --delete-conflicting-outputs
}
