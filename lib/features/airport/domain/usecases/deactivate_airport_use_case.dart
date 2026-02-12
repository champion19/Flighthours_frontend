import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class DeactivateAirportUseCase {
  final AirportRepository repository;
  DeactivateAirportUseCase({required this.repository});

  Future<Either<Failure, AirportStatusResponseModel>> call(String id) async {
    return await repository.deactivateAirport(id);
  }
}
