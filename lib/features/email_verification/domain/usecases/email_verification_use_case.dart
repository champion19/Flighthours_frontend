import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';

class EmailVerificationUseCase {
  final EmailVerificationRepository emailVerificationRepo;

  EmailVerificationUseCase(this.emailVerificationRepo);

  Future<EmailEntity> call(String email) async {
    return await emailVerificationRepo.verifyEmail(email);
  }
}
