import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';

class EmailVerificationUseCase {
  final EmailVerificationRepository emailVerificationRepo;

  EmailVerificationUseCase(this.emailVerificationRepo);

  Future<Either<Failure, EmailEntity>> call(String email) async {
    return await emailVerificationRepo.verifyEmail(email);
  }
}
