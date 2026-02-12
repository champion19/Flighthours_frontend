import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class ListAirlineUseCase {
  final AirlineRepository repository;

  ListAirlineUseCase({required this.repository});

  Future<Either<Failure, List<AirlineEntity>>> call() async {
    return await repository.getAirlines();
  }
}
