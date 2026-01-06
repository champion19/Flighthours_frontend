import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

abstract class EmailVerificationRepository {
  Future<EmailEntity> verifyEmail(String email);
  
}
