import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for deleting a logbook detail (flight segment)
class DeleteLogbookDetailUseCase {
  final LogbookRepository _repository;

  DeleteLogbookDetailUseCase({required LogbookRepository repository})
    : _repository = repository;

  /// Execute the use case
  /// [id] - The ID of the logbook detail to delete
  /// Returns true if deletion was successful
  Future<bool> call(String id) async {
    return await _repository.deleteLogbookDetail(id);
  }
}
