import 'package:flight_hours_app/features/email_verification/data/datasource/email_verifcation_datasource.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';

class EmailVerificationRepositoryImpl extends EmailVerificationRepository {
  final EmailVerificationDatasource emailVerificationDataSource;
  EmailVerificationRepositoryImpl(this.emailVerificationDataSource);

  @override
  Future<EmailEntity> verifyEmail(String email) {
    return emailVerificationDataSource.verifyEmail(email);
  }
}
