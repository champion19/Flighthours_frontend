import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';

class CrewMemberModel extends CrewMemberEntity {
  const CrewMemberModel({required super.id, required super.name, super.bp});

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bp: json['bp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (bp != null) 'bp': bp};
  }
}
