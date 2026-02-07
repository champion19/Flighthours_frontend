/// Response entity for aircraft model status update operations
class AircraftModelStatusResponseEntity {
  final bool success;
  final String code;
  final String message;
  final String? id;
  final String? status;
  final bool? updated;

  const AircraftModelStatusResponseEntity({
    required this.success,
    required this.code,
    required this.message,
    this.id,
    this.status,
    this.updated,
  });
}
