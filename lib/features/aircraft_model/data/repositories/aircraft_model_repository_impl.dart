import 'package:flight_hours_app/features/aircraft_model/data/datasources/aircraft_model_remote_data_source.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class AircraftModelRepositoryImpl implements AircraftModelRepository {
  final AircraftModelRemoteDataSource remoteDataSource;

  AircraftModelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AircraftModelEntity>> getAircraftModels() async {
    return await remoteDataSource.getAircraftModels();
  }

  @override
  Future<List<AircraftModelEntity>> getAircraftModelsByFamily(
    String family,
  ) async {
    return await remoteDataSource.getAircraftModelsByFamily(family);
  }

  @override
  Future<AircraftModelStatusResponseModel> activateAircraftModel(
    String id,
  ) async {
    return await remoteDataSource.activateAircraftModel(id);
  }

  @override
  Future<AircraftModelStatusResponseModel> deactivateAircraftModel(
    String id,
  ) async {
    return await remoteDataSource.deactivateAircraftModel(id);
  }
}
