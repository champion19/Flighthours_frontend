import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  final ResetPasswordRepository resetPasswordRepository;

  ResetPasswordUseCase(this.resetPasswordRepository);

  Future<ResetPasswordEntity> call(String email) async {
    return await resetPasswordRepository.requestPasswordReset(email);
  }
}
