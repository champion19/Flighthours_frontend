import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

abstract class ResetPasswordRepository {
  Future<ResetPasswordEntity> requestPasswordReset(String email);
}
