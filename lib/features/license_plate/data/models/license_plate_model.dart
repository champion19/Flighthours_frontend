import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';

/// Data model for License Plate
///
/// Extends [LicensePlateEntity] with JSON serialization
/// Maps snake_case keys from the Go backend
class LicensePlateModel extends LicensePlateEntity {
  const LicensePlateModel({
    required super.id,
    required super.licensePlate,
    super.modelName,
    super.airlineName,
    super.aircraftModelId,
    super.airlineId,
  });

  /// Creates a [LicensePlateModel] from a JSON map
  ///
  /// Backend response format:
  /// ```json
  /// {
  ///   "id": "G4WPSyeuAA9f5RMtXorU9JGT8VNtDrg",
  ///   "license_plate": "HK-1333",
  ///   "model_name": "A320-112",
  ///   "airline_name": "Latam",
  ///   "aircraft_model_id": "k2aBhGrDS1XxUNrZUAnBtn5RFxxBiaJD",
  ///   "airline_id": "vyY2TPnPHQRguoepinx5irokud88CeEW"
  /// }
  /// ```
  factory LicensePlateModel.fromJson(Map<String, dynamic> json) {
    return LicensePlateModel(
      id: json['id'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      modelName: json['model_name'],
      airlineName: json['airline_name'],
      aircraftModelId: json['aircraft_model_id'],
      airlineId: json['airline_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'license_plate': licensePlate,
      'model_name': modelName,
      'airline_name': airlineName,
      'aircraft_model_id': aircraftModelId,
      'airline_id': airlineId,
    };
  }
}
