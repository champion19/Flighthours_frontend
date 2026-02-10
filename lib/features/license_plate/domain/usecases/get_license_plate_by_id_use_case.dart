import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/repositories/license_plate_repository.dart';

/// Use case to search a license plate by its plate number
///
/// Calls GET /license-plates/:plate
class GetLicensePlateByPlateUseCase {
  final LicensePlateRepository _repository;

  GetLicensePlateByPlateUseCase(this._repository);

  Future<LicensePlateEntity> call(String plate) {
    return _repository.getLicensePlateByPlate(plate);
  }
}
