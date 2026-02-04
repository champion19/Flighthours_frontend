import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_daily_logbooks_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_logbook_details_use_case.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';

/// BLoC for managing logbook state
///
/// Supports dependency injection for testing:
/// - [listDailyLogbooksUseCase] for fetching daily logbooks
/// - [listLogbookDetailsUseCase] for fetching logbook details
/// - [deleteLogbookDetailUseCase] for deleting logbook details
class LogbookBloc extends Bloc<LogbookEvent, LogbookState> {
  final ListDailyLogbooksUseCase _listDailyLogbooksUseCase;
  final ListLogbookDetailsUseCase _listLogbookDetailsUseCase;
  final DeleteLogbookDetailUseCase _deleteLogbookDetailUseCase;

  // Track the current selected logbook for refresh operations
  DailyLogbookEntity? _currentSelectedLogbook;

  LogbookBloc({
    ListDailyLogbooksUseCase? listDailyLogbooksUseCase,
    ListLogbookDetailsUseCase? listLogbookDetailsUseCase,
    DeleteLogbookDetailUseCase? deleteLogbookDetailUseCase,
  }) : _listDailyLogbooksUseCase =
           listDailyLogbooksUseCase ??
           InjectorApp.resolve<ListDailyLogbooksUseCase>(),
       _listLogbookDetailsUseCase =
           listLogbookDetailsUseCase ??
           InjectorApp.resolve<ListLogbookDetailsUseCase>(),
       _deleteLogbookDetailUseCase =
           deleteLogbookDetailUseCase ??
           InjectorApp.resolve<DeleteLogbookDetailUseCase>(),
       super(const LogbookInitial()) {
    on<FetchDailyLogbooks>(_onFetchDailyLogbooks);
    on<SelectDailyLogbook>(_onSelectDailyLogbook);
    on<FetchLogbookDetails>(_onFetchLogbookDetails);
    on<DeleteLogbookDetail>(_onDeleteLogbookDetail);
    on<ClearSelectedLogbook>(_onClearSelectedLogbook);
    on<RefreshLogbook>(_onRefreshLogbook);
  }

  /// Handle fetching all daily logbooks
  Future<void> _onFetchDailyLogbooks(
    FetchDailyLogbooks event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    try {
      final logbooks = await _listDailyLogbooksUseCase.call();
      emit(DailyLogbooksLoaded(logbooks));
    } catch (e) {
      emit(LogbookError('Failed to load logbooks: ${e.toString()}'));
    }
  }

  /// Handle selecting a daily logbook and loading its details
  Future<void> _onSelectDailyLogbook(
    SelectDailyLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());
    _currentSelectedLogbook = event.logbook;

    try {
      // Use uuid if available, otherwise use id
      final logbookId = event.logbook.uuid ?? event.logbook.id;
      final details = await _listLogbookDetailsUseCase.call(logbookId);

      emit(
        LogbookDetailsLoaded(selectedLogbook: event.logbook, details: details),
      );
    } catch (e) {
      emit(LogbookError('Failed to load flight details: ${e.toString()}'));
    }
  }

  /// Handle fetching details for a specific logbook by ID
  Future<void> _onFetchLogbookDetails(
    FetchLogbookDetails event,
    Emitter<LogbookState> emit,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    try {
      final details = await _listLogbookDetailsUseCase.call(
        event.dailyLogbookId,
      );

      emit(
        LogbookDetailsLoaded(
          selectedLogbook: _currentSelectedLogbook!,
          details: details,
        ),
      );
    } catch (e) {
      emit(LogbookError('Failed to load flight details: ${e.toString()}'));
    }
  }

  /// Handle deleting a logbook detail
  Future<void> _onDeleteLogbookDetail(
    DeleteLogbookDetail event,
    Emitter<LogbookState> emit,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    try {
      final success = await _deleteLogbookDetailUseCase.call(event.detailId);

      if (success) {
        // Refresh the details list after successful deletion
        final details = await _listLogbookDetailsUseCase.call(
          event.dailyLogbookId,
        );

        emit(
          LogbookDetailDeleted(
            message: 'Flight record deleted successfully',
            selectedLogbook: _currentSelectedLogbook!,
            details: details,
          ),
        );
      } else {
        emit(const LogbookError('Failed to delete flight record'));
      }
    } catch (e) {
      emit(LogbookError('Error deleting flight record: ${e.toString()}'));
    }
  }

  /// Handle clearing the selected logbook (go back to list)
  Future<void> _onClearSelectedLogbook(
    ClearSelectedLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    _currentSelectedLogbook = null;
    emit(const LogbookLoading());

    try {
      final logbooks = await _listDailyLogbooksUseCase.call();
      emit(DailyLogbooksLoaded(logbooks));
    } catch (e) {
      emit(LogbookError('Failed to load logbooks: ${e.toString()}'));
    }
  }

  /// Handle refresh based on current state
  Future<void> _onRefreshLogbook(
    RefreshLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    try {
      if (_currentSelectedLogbook != null) {
        // Refresh details
        final logbookId =
            _currentSelectedLogbook!.uuid ?? _currentSelectedLogbook!.id;
        final details = await _listLogbookDetailsUseCase.call(logbookId);
        emit(
          LogbookDetailsLoaded(
            selectedLogbook: _currentSelectedLogbook!,
            details: details,
          ),
        );
      } else {
        // Refresh logbooks list
        final logbooks = await _listDailyLogbooksUseCase.call();
        emit(DailyLogbooksLoaded(logbooks));
      }
    } catch (e) {
      emit(LogbookError('Failed to refresh: ${e.toString()}'));
    }
  }
}
