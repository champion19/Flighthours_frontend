import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';

abstract class ManufacturerRepository {
  Future<Either<Failure, List<ManufacturerEntity>>> getManufacturers();
  Future<Either<Failure, ManufacturerEntity>> getManufacturerById(String id);
}
