import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginEntity>> loginEmployee(
    String email,
    String password,
  );
  Future<Either<Failure, void>> logoutEmployee();
}
