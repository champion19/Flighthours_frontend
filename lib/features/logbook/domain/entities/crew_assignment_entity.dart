import 'package:equatable/equatable.dart';

/// One First Officer/cabin crew assignment on a flight leg.
/// The captain is NOT represented here — that's the logged-in pilot
/// themselves, already covered by [LogbookDetailEntity.pilotRole]/companion.
class CrewAssignmentEntity extends Equatable {
  final String id;
  final String crewMemberId;
  final String name;
  final String? bp;
  final String role; // first_officer, purser, flight_attendant

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
