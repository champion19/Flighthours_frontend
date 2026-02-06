import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';

abstract class ManufacturerRepository {
  Future<List<ManufacturerEntity>> getManufacturers();
  Future<ManufacturerEntity?> getManufacturerById(String id);
}
