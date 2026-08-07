import 'package:equatable/equatable.dart';

/// Represents a person in a pilot's own crew roster (command crew or cabin
/// crew they've flown with before). Scoped per pilot on the backend.
class CrewMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? bp; // airline badge/ID number, optional

  const CrewMemberEntity({required this.id, required this.name, this.bp});

  @override
  List<Object?> get props => [id, name, bp];
}
