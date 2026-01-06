import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class GetAirportByIdUseCase {
  final AirportRepository repository;

  GetAirportByIdUseCase({required this.repository});

  Future<AirportEntity?> call(String id) async {
    return await repository.getAirportById(id);
  }
}
