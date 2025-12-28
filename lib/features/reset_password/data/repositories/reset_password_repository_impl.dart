import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl extends ResetPasswordRepository {
  final ResetPasswordDatasource resetPasswordDatasource;

  ResetPasswordRepositoryImpl(this.resetPasswordDatasource);

  @override
  Future<ResetPasswordEntity> requestPasswordReset(String email) async {
    return await resetPasswordDatasource.requestPasswordReset(email);
  }
}
