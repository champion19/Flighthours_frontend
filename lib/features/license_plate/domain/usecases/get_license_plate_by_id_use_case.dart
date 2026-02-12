import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/repositories/license_plate_repository.dart';

/// Use case to search a license plate by its plate number
class GetLicensePlateByPlateUseCase {
  final LicensePlateRepository _repository;

  GetLicensePlateByPlateUseCase(this._repository);

  Future<Either<Failure, LicensePlateEntity>> call(String plate) {
    return _repository.getLicensePlateByPlate(plate);
  }
}
