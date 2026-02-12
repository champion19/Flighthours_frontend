import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl extends ResetPasswordRepository {
  final ResetPasswordDatasource resetPasswordDatasource;

  ResetPasswordRepositoryImpl(this.resetPasswordDatasource);

  @override
  Future<Either<Failure, ResetPasswordEntity>> requestPasswordReset(
    String email,
  ) async {
    try {
      final result = await resetPasswordDatasource.requestPasswordReset(email);
      return Right(result);
    } on ResetPasswordException catch (e) {
      return Left(
        Failure(message: e.message, code: e.code, statusCode: e.statusCode),
      );
    } on DioException catch (e) {
      return Left(
        Failure(
          message: e.response?.data?['message']?.toString() ?? 'Server error',
          code: e.response?.data?['code']?.toString(),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
