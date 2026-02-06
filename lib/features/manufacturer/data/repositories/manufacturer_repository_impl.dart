import 'package:flight_hours_app/features/manufacturer/data/datasources/manufacturer_remote_data_source.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';

class ManufacturerRepositoryImpl implements ManufacturerRepository {
  final ManufacturerRemoteDataSource remoteDataSource;

  ManufacturerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ManufacturerEntity>> getManufacturers() async {
    return await remoteDataSource.getManufacturers();
  }

  @override
  Future<ManufacturerEntity?> getManufacturerById(String id) async {
    return await remoteDataSource.getManufacturerById(id);
  }
}
