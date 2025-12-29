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
      ..registerFactory((c) => LoginDatasource())
      ..registerFactory<RegisterRepository>(
          (c) => RegisterRepositoryImpl(c.resolve<RegisterDatasource>()))
      ..registerFactory((c) => RegisterUseCase(c.resolve<RegisterRepository>()))
      ..registerFactory((c) => RegisterDatasource())
      ..registerFactory(
          (c) => ListAirlineUseCase(repository: c.resolve<AirlineRepository>()))
      ..registerFactory<AirlineRepository>((c) => AirlineRepositoryImpl(
          remoteDataSource: c.resolve<AirlineRemoteDataSource>()))
      ..registerFactory<AirlineRemoteDataSource>(
          (c) => AirlineRemoteDataSourceImpl())
      ..registerFactory<EmailVerificationRepository>((c) =>
          EmailVerificationRepositoryImpl(
              c.resolve<EmailVerificationDatasource>()))
      ..registerFactory((c) =>
          EmailVerificationUseCase(c.resolve<EmailVerificationRepository>()))
      ..registerFactory((c) => EmailVerificationDatasource())
      ..registerFactory<ResetPasswordRepository>((c) =>
          ResetPasswordRepositoryImpl(c.resolve<ResetPasswordDatasource>()))
      ..registerFactory(
          (c) => ResetPasswordUseCase(c.resolve<ResetPasswordRepository>()))
      ..registerFactory((c) => ResetPasswordDatasource());
  }
}
