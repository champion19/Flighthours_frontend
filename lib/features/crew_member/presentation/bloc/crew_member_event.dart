import 'package:equatable/equatable.dart';

/// Events for the crew member (roster) BLoC
abstract class CrewMemberEvent extends Equatable {
  const CrewMemberEvent();

  @override
  List<Object?> get props => [];
}

/// Fetches the pilot's own roster (optionally filtered by name)
class FetchCrewMembers extends CrewMemberEvent {
  final String? search;

  const FetchCrewMembers({this.search});

  @override
  List<Object?> get props => [search];
}

/// Adds a new person to the roster (or resolves to the existing match by
/// name). If bp is given and the matched person has none on record, it's
/// filled in — an existing bp is never overwritten.
class CreateCrewMember extends CrewMemberEvent {
  final String name;
  final String? bp;

  const CreateCrewMember(this.name, {this.bp});

  @override
  List<Object?> get props => [name, bp];
}
