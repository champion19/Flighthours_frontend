import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for deleting a logbook detail (flight segment)
class DeleteLogbookDetailUseCase {
  final LogbookRepository _repository;

  DeleteLogbookDetailUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(String id) async {
    return await _repository.deleteLogbookDetail(id);
  }
}
