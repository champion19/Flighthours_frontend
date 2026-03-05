import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';

/// Data model for Tail Number
///
/// Extends [TailNumberEntity] with JSON serialization
/// Maps snake_case keys from the Go backend
class TailNumberModel extends TailNumberEntity {
  const TailNumberModel({
    required super.id,
    required super.tailNumber,
    super.modelName,
    super.airlineName,
    super.aircraftModelId,
    super.airlineId,
  });

  /// Creates a [TailNumberModel] from a JSON map
  ///
  /// Backend response format:
  /// ```json
  /// {
  ///   "id": "G4WPSyeuAA9f5RMtXorU9JGT8VNtDrg",
  ///   "tail_number": "HK-1333",
  ///   "model_name": "A320-112",
  ///   "airline_name": "Latam",
  ///   "aircraft_model_id": "k2aBhGrDS1XxUNrZUAnBtn5RFxxBiaJD",
  ///   "airline_id": "vyY2TPnPHQRguoepinx5irokud88CeEW"
  /// }
  /// ```
  factory TailNumberModel.fromJson(Map<String, dynamic> json) {
    return TailNumberModel(
      id: json['id'] ?? '',
      tailNumber: json['tail_number'] ?? '',
      modelName: json['model_name'],
      airlineName: json['airline_name'],
      aircraftModelId: json['aircraft_model_id'],
      airlineId: json['airline_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tail_number': tailNumber,
      'model_name': modelName,
      'airline_name': airlineName,
      'aircraft_model_id': aircraftModelId,
      'airline_id': airlineId,
    };
  }
}
