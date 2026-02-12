import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class GetAirportByIdUseCase {
  final AirportRepository repository;
  GetAirportByIdUseCase({required this.repository});

  Future<Either<Failure, AirportEntity>> call(String id) async {
    return await repository.getAirportById(id);
  }
}
