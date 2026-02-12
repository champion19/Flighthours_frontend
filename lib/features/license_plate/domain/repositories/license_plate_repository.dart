import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';

/// Abstract repository for License Plate operations
abstract class LicensePlateRepository {
  Future<Either<Failure, List<LicensePlateEntity>>> listLicensePlates();
  Future<Either<Failure, LicensePlateEntity>> getLicensePlateByPlate(
    String plate,
  );
}
