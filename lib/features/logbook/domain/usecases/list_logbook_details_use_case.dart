import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for listing all details (flight segments) of a daily logbook
class ListLogbookDetailsUseCase {
  final LogbookRepository _repository;

  ListLogbookDetailsUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<LogbookDetailEntity>>> call(
    String dailyLogbookId,
  ) async {
    return await _repository.getLogbookDetails(dailyLogbookId);
  }
}
