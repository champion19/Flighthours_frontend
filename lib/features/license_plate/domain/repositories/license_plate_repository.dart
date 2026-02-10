import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';

/// Abstract repository for License Plate operations
abstract class LicensePlateRepository {
  Future<List<LicensePlateEntity>> listLicensePlates();
  Future<LicensePlateEntity> getLicensePlateByPlate(String plate);
}
