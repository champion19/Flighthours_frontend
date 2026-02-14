import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for updating an existing daily logbook
class UpdateDailyLogbookUseCase {
  final LogbookRepository _repository;

  UpdateDailyLogbookUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, DailyLogbookEntity>> call({
    required String id,
    required DateTime logDate,
    int? bookPage,
  }) async {
    return await _repository.updateDailyLogbook(
      id: id,
      logDate: logDate,
      bookPage: bookPage,
    );
  }
}
