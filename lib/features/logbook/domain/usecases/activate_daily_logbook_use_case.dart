import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for activating a daily logbook via PATCH /daily-logbooks/:id/activate
class ActivateDailyLogbookUseCase {
  final LogbookRepository _repository;

  ActivateDailyLogbookUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(String id) async {
    return await _repository.activateDailyLogbook(id);
  }
}
