// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorApp extends InjectorApp {
  @override
  void _configureAuthFactories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory<LoginRepository>(
          (c) => LoginRepositoryImpl(c.resolve<LoginDatasource>()))
      ..registerFactory((c) => LoginUseCase(c.resolve<LoginRepository>()))
      ..registerFactory((c) => LoginDatasource(dio: c.resolve<Dio>()))
      ..registerFactory<RegisterRepository>(
          (c) => RegisterRepositoryImpl(c.resolve<RegisterDatasource>()))
      ..registerFactory((c) => RegisterUseCase(c.resolve<RegisterRepository>()))
      ..registerFactory((c) => RegisterDatasource(dio: c.resolve<Dio>()))
      ..registerFactory(
          (c) => ListAirlineUseCase(repository: c.resolve<AirlineRepository>()))
      ..registerFactory((c) =>
          GetAirlineByIdUseCase(repository: c.resolve<AirlineRepository>()))
      ..registerFactory((c) =>
          ActivateAirlineUseCase(repository: c.resolve<AirlineRepository>()))
      ..registerFactory((c) =>
          DeactivateAirlineUseCase(repository: c.resolve<AirlineRepository>()))
      ..registerFactory<AirlineRepository>((c) => AirlineRepositoryImpl(
          remoteDataSource: c.resolve<AirlineRemoteDataSource>()))
      ..registerFactory<AirlineRemoteDataSource>(
          (c) => AirlineRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory(
          (c) => ListAirportUseCase(repository: c.resolve<AirportRepository>()))
      ..registerFactory((c) =>
          GetAirportByIdUseCase(repository: c.resolve<AirportRepository>()))
      ..registerFactory((c) =>
          ActivateAirportUseCase(repository: c.resolve<AirportRepository>()))
      ..registerFactory((c) =>
          DeactivateAirportUseCase(repository: c.resolve<AirportRepository>()))
      ..registerFactory<AirportRepository>((c) => AirportRepositoryImpl(
          remoteDataSource: c.resolve<AirportRemoteDataSource>()))
      ..registerFactory<AirportRemoteDataSource>(
          (c) => AirportRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory((c) => ListAircraftModelUseCase(
          repository: c.resolve<AircraftModelRepository>()))
      ..registerFactory((c) => GetAircraftModelByIdUseCase(
          repository: c.resolve<AircraftModelRepository>()))
      ..registerFactory((c) => GetAircraftModelsByFamilyUseCase(
          repository: c.resolve<AircraftModelRepository>()))
      ..registerFactory((c) => ActivateAircraftModelUseCase(
          repository: c.resolve<AircraftModelRepository>()))
      ..registerFactory((c) => DeactivateAircraftModelUseCase(
          repository: c.resolve<AircraftModelRepository>()))
      ..registerFactory<AircraftModelRepository>((c) =>
          AircraftModelRepositoryImpl(
              remoteDataSource: c.resolve<AircraftModelRemoteDataSource>()))
      ..registerFactory<AircraftModelRemoteDataSource>(
          (c) => AircraftModelRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory<EmailVerificationRepository>((c) =>
          EmailVerificationRepositoryImpl(
              c.resolve<EmailVerificationDatasource>()))
      ..registerFactory((c) =>
          EmailVerificationUseCase(c.resolve<EmailVerificationRepository>()))
      ..registerFactory(
          (c) => EmailVerificationDatasource(dio: c.resolve<Dio>()))
      ..registerFactory<ResetPasswordRepository>((c) =>
          ResetPasswordRepositoryImpl(c.resolve<ResetPasswordDatasource>()))
      ..registerFactory(
          (c) => ResetPasswordUseCase(c.resolve<ResetPasswordRepository>()))
      ..registerFactory((c) => ResetPasswordDatasource(dio: c.resolve<Dio>()))
      ..registerFactory<EmployeeRepository>((c) => EmployeeRepositoryImpl())
      ..registerFactory<EmployeeRemoteDataSource>(
          (c) => EmployeeRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory((c) => GetEmployeeUseCase())
      ..registerFactory((c) => UpdateEmployeeUseCase())
      ..registerFactory((c) => ChangePasswordUseCase())
      ..registerFactory((c) => DeleteEmployeeUseCase())
      ..registerFactory((c) => GetEmployeeAirlineUseCase())
      ..registerFactory((c) => GetEmployeeAirlineRoutesUseCase())
      ..registerFactory((c) => UpdateEmployeeAirlineUseCase())
      ..registerFactory(
          (c) => ListRoutesUseCase(repository: c.resolve<RouteRepository>()))
      ..registerFactory(
          (c) => GetRouteByIdUseCase(repository: c.resolve<RouteRepository>()))
      ..registerFactory<RouteRepository>((c) => RouteRepositoryImpl(
          remoteDataSource: c.resolve<RouteRemoteDataSource>()))
      ..registerFactory<RouteRemoteDataSource>(
          (c) => RouteRemoteDataSourceImpl())
      ..registerFactory((c) => ListAirlineRoutesUseCase(
          repository: c.resolve<AirlineRouteRepository>()))
      ..registerFactory((c) => GetAirlineRouteByIdUseCase(
          repository: c.resolve<AirlineRouteRepository>()))
      ..registerFactory<AirlineRouteRepository>((c) =>
          AirlineRouteRepositoryImpl(
              remoteDataSource: c.resolve<AirlineRouteRemoteDataSource>()))
      ..registerFactory<AirlineRouteRemoteDataSource>(
          (c) => AirlineRouteRemoteDataSourceImpl())
      ..registerFactory((c) =>
          ListDailyLogbooksUseCase(repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) =>
          ListLogbookDetailsUseCase(repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) => GetLogbookDetailByIdUseCase(
          repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) => DeleteLogbookDetailUseCase(
          repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) => UpdateLogbookDetailUseCase(
          repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) =>
          DeleteDailyLogbookUseCase(repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) =>
          CreateDailyLogbookUseCase(repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) => ActivateDailyLogbookUseCase(
          repository: c.resolve<LogbookRepository>()))
      ..registerFactory((c) => DeactivateDailyLogbookUseCase(
          repository: c.resolve<LogbookRepository>()))
      ..registerFactory<LogbookRepository>((c) => LogbookRepositoryImpl(
          remoteDataSource: c.resolve<LogbookRemoteDataSource>()))
      ..registerFactory<LogbookRemoteDataSource>(
          (c) => LogbookRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory(
          (c) => ListLicensePlatesUseCase(c.resolve<LicensePlateRepository>()))
      ..registerFactory((c) =>
          GetLicensePlateByPlateUseCase(c.resolve<LicensePlateRepository>()))
      ..registerFactory<LicensePlateRepository>((c) =>
          LicensePlateRepositoryImpl(c.resolve<LicensePlateRemoteDataSource>()))
      ..registerFactory<LicensePlateRemoteDataSource>(
          (c) => LicensePlateRemoteDataSourceImpl(dio: c.resolve<Dio>()))
      ..registerFactory((c) => ListCrewMemberTypesUseCase(
          repository: c.resolve<CrewMemberTypeRepository>()))
      ..registerFactory<CrewMemberTypeRepository>((c) =>
          CrewMemberTypeRepositoryImpl(
              remoteDataSource: c.resolve<CrewMemberTypeRemoteDataSource>()))
      ..registerFactory<CrewMemberTypeRemoteDataSource>(
          (c) => CrewMemberTypeRemoteDataSourceImpl(dio: c.resolve<Dio>()));
  }
}
