import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for creating a new daily logbook
class CreateDailyLogbookUseCase {
  final LogbookRepository _repository;

  CreateDailyLogbookUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, DailyLogbookEntity>> call({
    required DateTime logDate,
    int? bookPage,
  }) async {
    return await _repository.createDailyLogbook(
      logDate: logDate,
      bookPage: bookPage ?? 1,
    );
  }
}
