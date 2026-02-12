import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for getting a specific logbook detail by ID
class GetLogbookDetailByIdUseCase {
  final LogbookRepository _repository;

  GetLogbookDetailByIdUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, LogbookDetailEntity>> call(String id) async {
    return await _repository.getLogbookDetailById(id);
  }
}
