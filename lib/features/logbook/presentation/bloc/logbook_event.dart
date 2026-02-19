import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

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

/// Event to fetch a single logbook detail by its ID
class FetchLogbookDetailById extends LogbookEvent {
  final String detailId;

  const FetchLogbookDetailById(this.detailId);

  @override
  List<Object?> get props => [detailId];
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

/// Event to create a new daily logbook
class CreateDailyLogbookEvent extends LogbookEvent {
  final DateTime logDate;
  final int? bookPage;

  const CreateDailyLogbookEvent({required this.logDate, this.bookPage});

  @override
  List<Object?> get props => [logDate, bookPage];
}

/// Event to activate a daily logbook
class ActivateDailyLogbookEvent extends LogbookEvent {
  final String id;

  const ActivateDailyLogbookEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to deactivate a daily logbook
class DeactivateDailyLogbookEvent extends LogbookEvent {
  final String id;

  const DeactivateDailyLogbookEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to delete a daily logbook
class DeleteDailyLogbookEvent extends LogbookEvent {
  final String id;

  const DeleteDailyLogbookEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to update an existing logbook detail (flight segment)
/// Carries the original detail for unchanged fields + edited values
class UpdateLogbookDetailEvent extends LogbookEvent {
  final LogbookDetailEntity originalDetail;
  final String dailyLogbookId; // To refresh details after update
  final int passengers;
  final String outTime;
  final String takeoffTime;
  final String landingTime;
  final String inTime;
  final String pilotRole;
  final String crewRole;
  final String? companionName;
  final String? airTime;
  final String? blockTime;
  final String? dutyTime;
  final String? approachType;
  final String? flightType;

  const UpdateLogbookDetailEvent({
    required this.originalDetail,
    required this.dailyLogbookId,
    required this.passengers,
    required this.outTime,
    required this.takeoffTime,
    required this.landingTime,
    required this.inTime,
    required this.pilotRole,
    required this.crewRole,
    this.companionName,
    this.airTime,
    this.blockTime,
    this.dutyTime,
    this.approachType,
    this.flightType,
  });

  @override
  List<Object?> get props => [
    originalDetail,
    dailyLogbookId,
    passengers,
    outTime,
    takeoffTime,
    landingTime,
    inTime,
    pilotRole,
    crewRole,
    companionName,
    airTime,
    blockTime,
    dutyTime,
    approachType,
    flightType,
  ];
}
