import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

abstract class EmailVerificationRepository {
  Future<Either<Failure, EmailEntity>> verifyEmail(String email);
}
