import 'package:equatable/equatable.dart';

/// Events for crew member type BLoC
abstract class CrewMemberTypeEvent extends Equatable {
  const CrewMemberTypeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch crew member types by role
class FetchCrewMemberTypes extends CrewMemberTypeEvent {
  final String role;

  const FetchCrewMemberTypes(this.role);

  @override
  List<Object?> get props => [role];
}
