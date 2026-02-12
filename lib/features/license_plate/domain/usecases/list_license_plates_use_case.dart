import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/repositories/license_plate_repository.dart';

/// Use case to list all license plates
class ListLicensePlatesUseCase {
  final LicensePlateRepository _repository;

  ListLicensePlatesUseCase(this._repository);

  Future<Either<Failure, List<LicensePlateEntity>>> call() {
    return _repository.listLicensePlates();
  }
}
