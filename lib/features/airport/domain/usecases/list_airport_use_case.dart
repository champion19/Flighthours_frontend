import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class ListAirportUseCase {
  final AirportRepository repository;
  ListAirportUseCase({required this.repository});

  Future<Either<Failure, List<AirportEntity>>> call() async {
    return await repository.getAirports();
  }
}
