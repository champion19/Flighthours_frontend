import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for deactivating a daily logbook via PATCH /daily-logbooks/:id/deactivate
class DeactivateDailyLogbookUseCase {
  final LogbookRepository _repository;

  DeactivateDailyLogbookUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(String id) async {
    return await _repository.deactivateDailyLogbook(id);
  }
}
