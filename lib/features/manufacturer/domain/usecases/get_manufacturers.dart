import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';

class GetManufacturers {
  final ManufacturerRepository repository;

  GetManufacturers(this.repository);

  Future<Either<Failure, List<ManufacturerEntity>>> call() async {
    return await repository.getManufacturers();
  }
}
