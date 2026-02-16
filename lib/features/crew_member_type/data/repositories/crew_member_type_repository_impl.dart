import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member_type/data/datasources/crew_member_type_remote_data_source.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/repositories/crew_member_type_repository.dart';
import 'package:dio/dio.dart';

/// Repository implementation for crew member type operations
class CrewMemberTypeRepositoryImpl implements CrewMemberTypeRepository {
  final CrewMemberTypeRemoteDataSource _remoteDataSource;

  CrewMemberTypeRepositoryImpl({
    required CrewMemberTypeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<CrewMemberTypeEntity>>> getCrewMemberTypes(
    String role,
  ) async {
    try {
      final types = await _remoteDataSource.getCrewMemberTypes(role);
      return Right(types);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return Failure(
            message: data['message'] ?? 'An error occurred',
            statusCode: response.statusCode ?? 500,
          );
        }
      }
      return Failure(
        message: error.message ?? 'Network error',
        statusCode: error.response?.statusCode ?? 500,
      );
    }
    return Failure(message: error.toString());
  }
}
