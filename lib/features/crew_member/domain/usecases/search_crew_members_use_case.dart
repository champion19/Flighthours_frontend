import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';
import 'package:flight_hours_app/features/crew_member/domain/repositories/crew_member_repository.dart';

/// Use case for fetching/searching the pilot's own crew roster
class SearchCrewMembersUseCase {
  final CrewMemberRepository _repository;

  SearchCrewMembersUseCase({required CrewMemberRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<CrewMemberEntity>>> call({String? search}) {
    return _repository.getCrewMembers(search: search);
  }
}
