import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';

/// Repository interface for crew member type operations
abstract class CrewMemberTypeRepository {
  /// Fetch crew member types by role
  Future<Either<Failure, List<CrewMemberTypeEntity>>> getCrewMemberTypes(
    String role,
  );
}
