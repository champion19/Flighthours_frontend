import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';
import 'package:flight_hours_app/features/crew_member/domain/repositories/crew_member_repository.dart';

/// Use case for adding a new person to the pilot's crew roster
class CreateCrewMemberUseCase {
  final CrewMemberRepository _repository;

  CreateCrewMemberUseCase({required CrewMemberRepository repository})
    : _repository = repository;

  Future<Either<Failure, CrewMemberEntity>> call(String name, {String? bp}) {
    return _repository.createCrewMember(name, bp: bp);
  }
}
