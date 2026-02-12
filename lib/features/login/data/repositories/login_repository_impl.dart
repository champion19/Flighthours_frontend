import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginDatasource loginDatasource;
  LoginRepositoryImpl(this.loginDatasource);

  @override
  Future<Either<Failure, LoginEntity>> loginEmployee(
    String email,
    String password,
  ) async {
    try {
      final result = await loginDatasource.loginEmployee(email, password);
      return Right(result);
    } on LoginException catch (e) {
      return Left(
        Failure(message: e.message, code: e.code, statusCode: e.statusCode),
      );
    } catch (e) {
      return Left(
        Failure(message: 'Unexpected error occurred', code: 'UNEXPECTED_ERROR'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logoutEmployee() async {
    // TODO: implement logoutEmployee
    return const Right(null);
  }
}
