import 'package:equatable/equatable.dart';

/// Entity representing a crew member type
class CrewMemberTypeEntity extends Equatable {
  final String id;
  final String? uuid;
  final String? name;
  final String? description;
  final String? status;

  const CrewMemberTypeEntity({
    required this.id,
    this.uuid,
    this.name,
    this.description,
    this.status,
  });

  bool get isActive => status?.toLowerCase() == 'active';

  String get displayStatus => isActive ? 'Active' : 'Inactive';

  @override
  List<Object?> get props => [id, uuid, name, description, status];
}
