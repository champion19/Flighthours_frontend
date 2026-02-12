import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<Either<Failure, LoginEntity>> call(
    String email,
    String password,
  ) async {
    return await loginRepository.loginEmployee(email, password);
  }
}
