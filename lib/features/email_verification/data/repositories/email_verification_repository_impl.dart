import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/email_verification/data/datasource/email_verifcation_datasource.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';

class EmailVerificationRepositoryImpl extends EmailVerificationRepository {
  final EmailVerificationDatasource emailVerificationDataSource;
  EmailVerificationRepositoryImpl(this.emailVerificationDataSource);

  @override
  Future<Either<Failure, EmailEntity>> verifyEmail(String email) async {
    try {
      final result = await emailVerificationDataSource.verifyEmail(email);
      return Right(result);
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
