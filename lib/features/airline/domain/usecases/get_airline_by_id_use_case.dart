import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class GetAirlineByIdUseCase {
  final AirlineRepository repository;

  GetAirlineByIdUseCase({required this.repository});

  Future<AirlineEntity?> call(String id) async {
    return await repository.getAirlineById(id);
  }
}
