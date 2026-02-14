import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

/// Base class for all logbook states
abstract class LogbookState extends Equatable {
  const LogbookState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class LogbookInitial extends LogbookState {
  const LogbookInitial();
}

/// Loading state while fetching data
class LogbookLoading extends LogbookState {
  const LogbookLoading();
}

/// State when daily logbooks have been loaded successfully
class DailyLogbooksLoaded extends LogbookState {
  final List<DailyLogbookEntity> logbooks;

  const DailyLogbooksLoaded(this.logbooks);

  @override
  List<Object?> get props => [logbooks];
}

/// State when logbook details have been loaded successfully
class LogbookDetailsLoaded extends LogbookState {
  final DailyLogbookEntity selectedLogbook;
  final List<LogbookDetailEntity> details;

  const LogbookDetailsLoaded({
    required this.selectedLogbook,
    required this.details,
  });

  @override
  List<Object?> get props => [selectedLogbook, details];
}

/// Error state when something goes wrong
class LogbookError extends LogbookState {
  final String message;

  const LogbookError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a detail was successfully deleted
class LogbookDetailDeleted extends LogbookState {
  final String message;
  final DailyLogbookEntity selectedLogbook;
  final List<LogbookDetailEntity> details;

  const LogbookDetailDeleted({
    required this.message,
    required this.selectedLogbook,
    required this.details,
  });

  @override
  List<Object?> get props => [message, selectedLogbook, details];
}

/// State when a daily logbook was successfully created
class DailyLogbookCreated extends LogbookState {
  final String message;

  const DailyLogbookCreated({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a daily logbook status was changed (activated/deactivated)
class DailyLogbookStatusChanged extends LogbookState {
  final String message;

  const DailyLogbookStatusChanged({required this.message});

  @override
  List<Object?> get props => [message];
}
