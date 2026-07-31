import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';

/// States for the crew member (roster) BLoC
abstract class CrewMemberState extends Equatable {
  const CrewMemberState();

  @override
  List<Object?> get props => [];
}

class CrewMemberInitial extends CrewMemberState {
  const CrewMemberInitial();
}

class CrewMemberLoading extends CrewMemberState {
  const CrewMemberLoading();
}

/// Roster fetched successfully
class CrewMembersLoaded extends CrewMemberState {
  final List<CrewMemberEntity> members;

  const CrewMembersLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

/// A new crew member was just added (or matched an existing one).
/// Carries the full roster too, so the UI can refresh its list in one state.
class CrewMemberCreated extends CrewMemberState {
  final CrewMemberEntity member;
  final List<CrewMemberEntity> members;

  const CrewMemberCreated(this.member, this.members);

  @override
  List<Object?> get props => [member, members];
}

class CrewMemberError extends CrewMemberState {
  final String message;

  const CrewMemberError(this.message);

  @override
  List<Object?> get props => [message];
}
