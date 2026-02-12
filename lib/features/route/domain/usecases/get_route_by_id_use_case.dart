import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

class GetRouteByIdUseCase {
  final RouteRepository repository;
  GetRouteByIdUseCase({required this.repository});

  Future<Either<Failure, RouteEntity>> call(String id) async {
    return await repository.getRouteById(id);
  }
}
