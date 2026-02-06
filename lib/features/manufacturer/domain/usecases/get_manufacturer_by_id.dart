import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';

class GetManufacturerById {
  final ManufacturerRepository repository;

  GetManufacturerById(this.repository);

  Future<ManufacturerEntity?> call(String id) async {
    return await repository.getManufacturerById(id);
  }
}
