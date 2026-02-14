import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/repositories/crew_member_type_repository.dart';

/// Use case for listing crew member types by role
class ListCrewMemberTypesUseCase {
  final CrewMemberTypeRepository _repository;

  ListCrewMemberTypesUseCase({required CrewMemberTypeRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<CrewMemberTypeEntity>>> call(String role) async {
    return await _repository.getCrewMemberTypes(role);
  }
}
