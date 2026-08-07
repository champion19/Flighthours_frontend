import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';

/// Repository interface for the authenticated pilot's own crew roster
abstract class CrewMemberRepository {
  /// Fetch the pilot's roster, optionally filtered by name
  Future<Either<Failure, List<CrewMemberEntity>>> getCrewMembers({
    String? search,
  });

  /// Add a person to the roster, or return the existing match by name.
  /// If bp is provided and the matched person doesn't have one on record yet,
  /// the backend fills it in (never overwrites an existing bp).
  Future<Either<Failure, CrewMemberEntity>> createCrewMember(
    String name, {
    String? bp,
  });
}
