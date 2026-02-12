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

  Future<void> _onFetchDailyLogbooks(
    FetchDailyLogbooks event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final result = await _listDailyLogbooksUseCase.call();
    result.fold(
      (failure) =>
          emit(LogbookError('Failed to load logbooks: ${failure.message}')),
      (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
    );
  }

  Future<void> _onSelectDailyLogbook(
    SelectDailyLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());
    _currentSelectedLogbook = event.logbook;

    final logbookId = event.logbook.uuid ?? event.logbook.id;
    final result = await _listLogbookDetailsUseCase.call(logbookId);
    result.fold(
      (failure) => emit(
        LogbookError('Failed to load flight details: ${failure.message}'),
      ),
      (details) => emit(
        LogbookDetailsLoaded(selectedLogbook: event.logbook, details: details),
      ),
    );
  }

  Future<void> _onFetchLogbookDetails(
    FetchLogbookDetails event,
    Emitter<LogbookState> emit,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    final result = await _listLogbookDetailsUseCase.call(event.dailyLogbookId);
    result.fold(
      (failure) => emit(
        LogbookError('Failed to load flight details: ${failure.message}'),
      ),
      (details) => emit(
        LogbookDetailsLoaded(
          selectedLogbook: _currentSelectedLogbook!,
          details: details,
        ),
      ),
    );
  }

  Future<void> _onDeleteLogbookDetail(
    DeleteLogbookDetail event,
    Emitter<LogbookState> emit,
  ) async {
    if (_currentSelectedLogbook == null) {
      emit(const LogbookError('No logbook selected'));
      return;
    }

    emit(const LogbookLoading());

    final deleteResult = await _deleteLogbookDetailUseCase.call(event.detailId);
    await deleteResult.fold(
      (failure) async => emit(
        LogbookError('Error deleting flight record: ${failure.message}'),
      ),
      (success) async {
        if (success) {
          // Refresh the details list after successful deletion
          final detailsResult = await _listLogbookDetailsUseCase.call(
            event.dailyLogbookId,
          );
          detailsResult.fold(
            (failure) =>
                emit(LogbookError('Failed to refresh: ${failure.message}')),
            (details) => emit(
              LogbookDetailDeleted(
                message: 'Flight record deleted successfully',
                selectedLogbook: _currentSelectedLogbook!,
                details: details,
              ),
            ),
          );
        } else {
          emit(const LogbookError('Failed to delete flight record'));
        }
      },
    );
  }

  Future<void> _onClearSelectedLogbook(
    ClearSelectedLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    _currentSelectedLogbook = null;
    emit(const LogbookLoading());

    final result = await _listDailyLogbooksUseCase.call();
    result.fold(
      (failure) =>
          emit(LogbookError('Failed to load logbooks: ${failure.message}')),
      (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
    );
  }

  Future<void> _onRefreshLogbook(
    RefreshLogbook event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    if (_currentSelectedLogbook != null) {
      final logbookId =
          _currentSelectedLogbook!.uuid ?? _currentSelectedLogbook!.id;
      final result = await _listLogbookDetailsUseCase.call(logbookId);
      result.fold(
        (failure) =>
            emit(LogbookError('Failed to refresh: ${failure.message}')),
        (details) => emit(
          LogbookDetailsLoaded(
            selectedLogbook: _currentSelectedLogbook!,
            details: details,
          ),
        ),
      );
    } else {
      final result = await _listDailyLogbooksUseCase.call();
      result.fold(
        (failure) =>
            emit(LogbookError('Failed to refresh: ${failure.message}')),
        (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
      );
    }
  }
}
