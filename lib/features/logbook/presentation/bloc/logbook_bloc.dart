import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_daily_logbooks_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_logbook_details_use_case.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';

/// BLoC for managing logbook state
class LogbookBloc extends Bloc<LogbookEvent, LogbookState> {
  // Track the current selected logbook for refresh operations
  DailyLogbookEntity? _currentSelectedLogbook;

  LogbookBloc() : super(const LogbookInitial()) {
    // Resolve use cases from injector
    final listDailyLogbooksUseCase =
        InjectorApp.resolve<ListDailyLogbooksUseCase>();
    final listLogbookDetailsUseCase =
        InjectorApp.resolve<ListLogbookDetailsUseCase>();
    final deleteLogbookDetailUseCase =
        InjectorApp.resolve<DeleteLogbookDetailUseCase>();

    on<FetchDailyLogbooks>(
      (event, emit) =>
          _onFetchDailyLogbooks(event, emit, listDailyLogbooksUseCase),
    );
    on<SelectDailyLogbook>(
      (event, emit) =>
          _onSelectDailyLogbook(event, emit, listLogbookDetailsUseCase),
    );
    on<FetchLogbookDetails>(
      (event, emit) =>
          _onFetchLogbookDetails(event, emit, listLogbookDetailsUseCase),
    );
    on<DeleteLogbookDetail>(
      (event, emit) => _onDeleteLogbookDetail(
        event,
        emit,
        deleteLogbookDetailUseCase,
        listLogbookDetailsUseCase,
      ),
    );
    on<ClearSelectedLogbook>(
      (event, emit) =>
          _onClearSelectedLogbook(event, emit, listDailyLogbooksUseCase),
    );
    on<RefreshLogbook>(
      (event, emit) => _onRefreshLogbook(
        event,
        emit,
        listDailyLogbooksUseCase,
        listLogbookDetailsUseCase,
      ),
    );
  }

  /// Handle fetching all daily logbooks
  Future<void> _onFetchDailyLogbooks(
    FetchDailyLogbooks event,
    Emitter<LogbookState> emit,
    ListDailyLogbooksUseCase listDailyLogbooksUseCase,
  ) async {
    emit(const LogbookLoading());

    try {
      final logbooks = await listDailyLogbooksUseCase.call();
      emit(DailyLogbooksLoaded(logbooks));
    } catch (e) {
      emit(LogbookError('Failed to load logbooks: ${e.toString()}'));
    }
  }

  /// Handle selecting a daily logbook and loading its details
  Future<void> _onSelectDailyLogbook(
    SelectDailyLogbook event,
    Emitter<LogbookState> emit,
    ListLogbookDetailsUseCase listLogbookDetailsUseCase,
  ) async {
    emit(const LogbookLoading());
    _currentSelectedLogbook = event.logbook;

    try {
      // Use uuid if available, otherwise use id
      final logbookId = event.logbook.uuid ?? event.logbook.id;
      final details = await listLogbookDetailsUseCase.call(logbookId);

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
    ListLogbookDetailsUseCase listLogbookDetailsUseCase,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    try {
      final details = await listLogbookDetailsUseCase.call(
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
    DeleteLogbookDetailUseCase deleteLogbookDetailUseCase,
    ListLogbookDetailsUseCase listLogbookDetailsUseCase,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    try {
      final success = await deleteLogbookDetailUseCase.call(event.detailId);

      if (success) {
        // Refresh the details list after successful deletion
        final details = await listLogbookDetailsUseCase.call(
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
    ListDailyLogbooksUseCase listDailyLogbooksUseCase,
  ) async {
    _currentSelectedLogbook = null;
    emit(const LogbookLoading());

    try {
      final logbooks = await listDailyLogbooksUseCase.call();
      emit(DailyLogbooksLoaded(logbooks));
    } catch (e) {
      emit(LogbookError('Failed to load logbooks: ${e.toString()}'));
    }
  }

  /// Handle refresh based on current state
  Future<void> _onRefreshLogbook(
    RefreshLogbook event,
    Emitter<LogbookState> emit,
    ListDailyLogbooksUseCase listDailyLogbooksUseCase,
    ListLogbookDetailsUseCase listLogbookDetailsUseCase,
  ) async {
    emit(const LogbookLoading());

    try {
      if (_currentSelectedLogbook != null) {
        // Refresh details
        final logbookId =
            _currentSelectedLogbook!.uuid ?? _currentSelectedLogbook!.id;
        final details = await listLogbookDetailsUseCase.call(logbookId);
        emit(
          LogbookDetailsLoaded(
            selectedLogbook: _currentSelectedLogbook!,
            details: details,
          ),
        );
      } else {
        // Refresh logbooks list
        final logbooks = await listDailyLogbooksUseCase.call();
        emit(DailyLogbooksLoaded(logbooks));
      }
    } catch (e) {
      emit(LogbookError('Failed to refresh: ${e.toString()}'));
    }
  }
}
