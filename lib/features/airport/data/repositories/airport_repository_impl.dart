import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class AirportRepositoryImpl implements AirportRepository {
  final AirportRemoteDataSource remoteDataSource;

  AirportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AirportEntity>> getAirports() async {
    return await remoteDataSource.getAirports();
  }

  @override
  Future<AirportEntity?> getAirportById(String id) async {
    return await remoteDataSource.getAirportById(id);
  }

  @override
  Future<AirportStatusResponseModel> activateAirport(String id) async {
    return await remoteDataSource.activateAirport(id);
  }

  @override
  Future<AirportStatusResponseModel> deactivateAirport(String id) async {
    return await remoteDataSource.deactivateAirport(id);
  }
}
