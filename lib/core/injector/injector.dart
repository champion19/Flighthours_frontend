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
import 'package:flight_hours_app/features/register/domain/usecases/register_use_case.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';
import 'package:kiwi/kiwi.dart';

import '../../features/login/data/repositories/login_repository_impl.dart';

part 'injector.g.dart';

abstract class InjectorApp {
  static KiwiContainer container = KiwiContainer();
  static void setyp() {
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
  @Register.factory(AirlineRepository, from: AirlineRepositoryImpl)
  @Register.factory(AirlineRemoteDataSource, from: AirlineRemoteDataSourceImpl)
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
  void _configureAuthFactories();
  // comando para crear el archivo que genera el paquete injector: flutter pub run build_runner build --delete-conflicting-outputs
}
