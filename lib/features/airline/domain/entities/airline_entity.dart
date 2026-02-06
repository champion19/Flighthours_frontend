import 'package:equatable/equatable.dart';

class AirlineEntity extends Equatable {
  final String id; // Obfuscated ID
  final String? uuid; // Real UUID from database
  final String name;
  final String? code;
  final bool active; // Status of the airline

  const AirlineEntity({
    required this.id,
    this.uuid,
    required this.name,
    this.code,
    this.active = true,
  });

  @override
  List<Object?> get props => [id, uuid, name, code, active];
}
