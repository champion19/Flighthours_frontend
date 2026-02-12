import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, ResetPasswordEntity>> requestPasswordReset(
    String email,
  );
}
