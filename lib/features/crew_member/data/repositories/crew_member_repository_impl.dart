import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member/data/datasources/crew_member_remote_data_source.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';
import 'package:flight_hours_app/features/crew_member/domain/repositories/crew_member_repository.dart';

/// Repository implementation for the pilot's own crew roster
class CrewMemberRepositoryImpl implements CrewMemberRepository {
  final CrewMemberRemoteDataSource _remoteDataSource;

  CrewMemberRepositoryImpl({required CrewMemberRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<CrewMemberEntity>>> getCrewMembers({
    String? search,
  }) async {
    try {
      final members = await _remoteDataSource.getCrewMembers(search: search);
      return Right(members);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, CrewMemberEntity>> createCrewMember(
    String name, {
    String? bp,
  }) async {
    try {
      final member = await _remoteDataSource.createCrewMember(name, bp: bp);
      return Right(member);
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
