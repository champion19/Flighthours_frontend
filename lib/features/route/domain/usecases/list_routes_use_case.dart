import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

class ListRoutesUseCase {
  final RouteRepository repository;
  ListRoutesUseCase({required this.repository});

  Future<Either<Failure, List<RouteEntity>>> call() async {
    return await repository.getRoutes();
  }
}
