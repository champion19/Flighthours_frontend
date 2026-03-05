import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/repositories/tail_number_repository.dart';

/// Use case to list all tail numbers
class ListTailNumbersUseCase {
  final TailNumberRepository _repository;

  ListTailNumbersUseCase(this._repository);

  Future<Either<Failure, List<TailNumberEntity>>> call() {
    return _repository.listTailNumbers();
  }
}
