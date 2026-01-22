import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';

/// Base class for all logbook events
abstract class LogbookEvent extends Equatable {
  const LogbookEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all daily logbooks for the authenticated employee
class FetchDailyLogbooks extends LogbookEvent {
  const FetchDailyLogbooks();
}

/// Event to select a specific daily logbook and load its details
class SelectDailyLogbook extends LogbookEvent {
  final DailyLogbookEntity logbook;

  const SelectDailyLogbook(this.logbook);

  @override
  List<Object?> get props => [logbook];
}

/// Event to fetch details for a specific daily logbook
class FetchLogbookDetails extends LogbookEvent {
  final String dailyLogbookId;

  const FetchLogbookDetails(this.dailyLogbookId);

  @override
  List<Object?> get props => [dailyLogbookId];
}

/// Event to delete a logbook detail
class DeleteLogbookDetail extends LogbookEvent {
  final String detailId;
  final String dailyLogbookId; // To refresh the list after deletion

  const DeleteLogbookDetail({
    required this.detailId,
    required this.dailyLogbookId,
  });

  @override
  List<Object?> get props => [detailId, dailyLogbookId];
}

/// Event to clear the selected logbook and go back to the list
class ClearSelectedLogbook extends LogbookEvent {
  const ClearSelectedLogbook();
}

/// Event to refresh the current view (logbooks or details)
class RefreshLogbook extends LogbookEvent {
  const RefreshLogbook();
}
