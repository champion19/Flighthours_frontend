import 'package:equatable/equatable.dart';

class ManufacturerEntity extends Equatable {
  final String id; // Obfuscated ID
  final String? uuid; // Real UUID from database
  final String name;
  final String? country;
  final String? description;
  final String? status; // "active" or "inactive"

  const ManufacturerEntity({
    required this.id,
    this.uuid,
    required this.name,
    this.country,
    this.description,
    this.status,
  });

  @override
  List<Object?> get props => [id, uuid, name, country, description, status];
}
