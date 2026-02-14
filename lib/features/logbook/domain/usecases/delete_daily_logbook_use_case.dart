import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for deleting a daily logbook via DELETE /daily-logbooks/:id
class DeleteDailyLogbookUseCase {
  final LogbookRepository _repository;

  DeleteDailyLogbookUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(String id) async {
    return await _repository.deleteDailyLogbook(id);
  }
}
