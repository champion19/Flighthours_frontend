import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/repositories/tail_number_repository.dart';

/// Use case to search a tail number by its plate number
class GetTailNumberByPlateUseCase {
  final TailNumberRepository _repository;

  GetTailNumberByPlateUseCase(this._repository);

  Future<Either<Failure, TailNumberEntity>> call(String plate) {
    return _repository.getTailNumberByPlate(plate);
  }
}
