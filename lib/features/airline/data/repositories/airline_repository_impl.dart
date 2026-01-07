import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class AirlineRepositoryImpl implements AirlineRepository {
  final AirlineRemoteDataSource remoteDataSource;

  AirlineRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AirlineEntity>> getAirlines() async {
    return await remoteDataSource.getAirlines();
  }

  @override
  Future<AirlineEntity?> getAirlineById(String id) async {
    return await remoteDataSource.getAirlineById(id);
  }

  @override
  Future<AirlineStatusResponseModel> activateAirline(String id) async {
    return await remoteDataSource.activateAirline(id);
  }

  @override
  Future<AirlineStatusResponseModel> deactivateAirline(String id) async {
    return await remoteDataSource.deactivateAirline(id);
  }
}
