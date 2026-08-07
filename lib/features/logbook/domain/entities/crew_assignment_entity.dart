import 'package:equatable/equatable.dart';

/// One command crew/cabin crew assignment on a flight leg.
/// The logged-in pilot is NOT represented here — their own role is
/// [LogbookDetailEntity.crewRole].
class CrewAssignmentEntity extends Equatable {
  final String id;
  final String crewMemberId;
  final String name;
  final String? bp;
  // Command crew: captain, first officer, instructor, line check captain,
  // safety pilot (see kCommandCrewRoles in crew_section.dart). Cabin crew:
  // purser, flight_attendant. Legacy rows may still say first_officer.
  final String role;

  const CrewAssignmentEntity({
    this.id = '',
    required this.crewMemberId,
    required this.name,
    this.bp,
    required this.role,
  });

  @override
  List<Object?> get props => [id, crewMemberId, name, bp, role];
}
