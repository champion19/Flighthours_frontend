import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/create_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_daily_logbook_use_case.dart';

import 'package:flight_hours_app/features/logbook/domain/usecases/activate_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/deactivate_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/update_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/get_logbook_detail_by_id_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_daily_logbooks_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_logbook_details_use_case.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';

/// BLoC for managing logbook state
class LogbookBloc extends Bloc<LogbookEvent, LogbookState> {
  final ListDailyLogbooksUseCase _listDailyLogbooksUseCase;
  final ListLogbookDetailsUseCase _listLogbookDetailsUseCase;
  final DeleteLogbookDetailUseCase _deleteLogbookDetailUseCase;
  final CreateDailyLogbookUseCase _createDailyLogbookUseCase;
  final DeleteDailyLogbookUseCase _deleteDailyLogbookUseCase;

  final ActivateDailyLogbookUseCase _activateDailyLogbookUseCase;
  final DeactivateDailyLogbookUseCase _deactivateDailyLogbookUseCase;
  final UpdateLogbookDetailUseCase _updateLogbookDetailUseCase;
  final GetLogbookDetailByIdUseCase _getLogbookDetailByIdUseCase;

  // Track the current selected logbook for refresh operations
  DailyLogbookEntity? _currentSelectedLogbook;

  LogbookBloc({
    ListDailyLogbooksUseCase? listDailyLogbooksUseCase,
    ListLogbookDetailsUseCase? listLogbookDetailsUseCase,
    DeleteLogbookDetailUseCase? deleteLogbookDetailUseCase,
    CreateDailyLogbookUseCase? createDailyLogbookUseCase,
    DeleteDailyLogbookUseCase? deleteDailyLogbookUseCase,

    ActivateDailyLogbookUseCase? activateDailyLogbookUseCase,
    DeactivateDailyLogbookUseCase? deactivateDailyLogbookUseCase,
    UpdateLogbookDetailUseCase? updateLogbookDetailUseCase,
    GetLogbookDetailByIdUseCase? getLogbookDetailByIdUseCase,
  }) : _listDailyLogbooksUseCase =
           listDailyLogbooksUseCase ??
           InjectorApp.resolve<ListDailyLogbooksUseCase>(),
       _listLogbookDetailsUseCase =
           listLogbookDetailsUseCase ??
           InjectorApp.resolve<ListLogbookDetailsUseCase>(),
       _deleteLogbookDetailUseCase =
           deleteLogbookDetailUseCase ??
           InjectorApp.resolve<DeleteLogbookDetailUseCase>(),
       _createDailyLogbookUseCase =
           createDailyLogbookUseCase ??
           InjectorApp.resolve<CreateDailyLogbookUseCase>(),
       _deleteDailyLogbookUseCase =
           deleteDailyLogbookUseCase ??
           InjectorApp.resolve<DeleteDailyLogbookUseCase>(),

       _activateDailyLogbookUseCase =
           activateDailyLogbookUseCase ??
           InjectorApp.resolve<ActivateDailyLogbookUseCase>(),
       _deactivateDailyLogbookUseCase =
           deactivateDailyLogbookUseCase ??
           InjectorApp.resolve<DeactivateDailyLogbookUseCase>(),
       _updateLogbookDetailUseCase =
           updateLogbookDetailUseCase ??
           InjectorApp.resolve<UpdateLogbookDetailUseCase>(),
       _getLogbookDetailByIdUseCase =
           getLogbookDetailByIdUseCase ??
           InjectorApp.resolve<GetLogbookDetailByIdUseCase>(),
       super(const LogbookInitial()) {
    on<FetchDailyLogbooks>(_onFetchDailyLogbooks);
    on<SelectDailyLogbook>(_onSelectDailyLogbook);
    on<FetchLogbookDetails>(_onFetchLogbookDetails);
    on<DeleteLogbookDetail>(_onDeleteLogbookDetail);
    on<ClearSelectedLogbook>(_onClearSelectedLogbook);
    on<RefreshLogbook>(_onRefreshLogbook);
    on<CreateDailyLogbookEvent>(_onCreateDailyLogbook);

    on<ActivateDailyLogbookEvent>(_onActivateDailyLogbook);
    on<DeactivateDailyLogbookEvent>(_onDeactivateDailyLogbook);
    on<DeleteDailyLogbookEvent>(_onDeleteDailyLogbook);
    on<UpdateLogbookDetailEvent>(_onUpdateLogbookDetail);
    on<FetchLogbookDetailById>(_onFetchLogbookDetailById);
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

    // Use the obfuscated ID — the endpoint expects it, not the real UUID
    final logbookId = event.logbook.id;
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

  Future<void> _onCreateDailyLogbook(
    CreateDailyLogbookEvent event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final result = await _createDailyLogbookUseCase.call(
      logDate: event.logDate,
      bookPage: event.bookPage,
    );
    await result.fold(
      (failure) async {
        emit(LogbookError('Failed to create logbook: ${failure.message}'));
        // Re-fetch list so UI stays on the list view (SnackBar shows the error)
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (_) => null,
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
      (logbook) async {
        emit(
          const DailyLogbookCreated(message: 'Logbook created successfully'),
        );
        // Auto-refresh the list
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (failure) =>
              emit(LogbookError('Failed to refresh: ${failure.message}')),
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
    );
  }

  Future<void> _onActivateDailyLogbook(
    ActivateDailyLogbookEvent event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final result = await _activateDailyLogbookUseCase.call(event.id);
    await result.fold(
      (failure) async {
        emit(LogbookError('Failed to activate logbook: ${failure.message}'));
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (_) => null,
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
      (success) async {
        emit(
          const DailyLogbookStatusChanged(
            message: 'Logbook activated successfully',
          ),
        );
        // Auto-refresh the list
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (failure) =>
              emit(LogbookError('Failed to refresh: ${failure.message}')),
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
    );
  }

  Future<void> _onDeactivateDailyLogbook(
    DeactivateDailyLogbookEvent event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final result = await _deactivateDailyLogbookUseCase.call(event.id);
    await result.fold(
      (failure) async {
        emit(LogbookError('Failed to deactivate logbook: ${failure.message}'));
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (_) => null,
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
      (success) async {
        emit(
          const DailyLogbookStatusChanged(
            message: 'Logbook deactivated successfully',
          ),
        );
        // Auto-refresh the list
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (failure) =>
              emit(LogbookError('Failed to refresh: ${failure.message}')),
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
    );
  }

  Future<void> _onDeleteDailyLogbook(
    DeleteDailyLogbookEvent event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final result = await _deleteDailyLogbookUseCase.call(event.id);
    await result.fold(
      (failure) async {
        emit(LogbookError('Failed to delete logbook: ${failure.message}'));
        final listResult = await _listDailyLogbooksUseCase.call();
        listResult.fold(
          (_) => null,
          (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
        );
      },
      (success) async {
        if (success) {
          _currentSelectedLogbook = null;
          emit(
            const DailyLogbookDeleted(message: 'Logbook deleted successfully'),
          );
          // Auto-refresh the list
          final listResult = await _listDailyLogbooksUseCase.call();
          listResult.fold(
            (failure) =>
                emit(LogbookError('Failed to refresh: ${failure.message}')),
            (logbooks) => emit(DailyLogbooksLoaded(logbooks)),
          );
        } else {
          emit(const LogbookError('Failed to delete logbook'));
        }
      },
    );
  }

  // ══ Update Logbook Detail ══════════════════════════════════
  Future<void> _onUpdateLogbookDetail(
    UpdateLogbookDetailEvent event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());

    final detail = event.originalDetail;

    final result = await _updateLogbookDetailUseCase.call(
      id: detail.uuid ?? detail.id,
      flightRealDate:
          detail.flightRealDate?.toIso8601String().split('T').first ?? '',
      flightNumber: detail.flightNumber ?? '',
      airlineRouteId: detail.airlineRouteId ?? '',
      licensePlateId: detail.actualAircraftRegistrationId ?? '',
      passengers: event.passengers,
      outTime: event.outTime,
      takeoffTime: event.takeoffTime,
      landingTime: event.landingTime,
      inTime: event.inTime,
      pilotRole: event.pilotRole,
      crewRole: event.crewRole,
      companionName: event.companionName,
      airTime: event.airTime,
      blockTime: event.blockTime,
      dutyTime: event.dutyTime,
      approachType: event.approachType,
      flightType: event.flightType,
    );

    result.fold(
      (failure) =>
          emit(LogbookError('Failed to update flight: ${failure.message}')),
      (updatedDetail) => emit(
        const LogbookDetailUpdated(message: 'Flight updated successfully'),
      ),
    );
  }

  /// Fetch a single logbook detail by its ID from the backend
  Future<void> _onFetchLogbookDetailById(
    FetchLogbookDetailById event,
    Emitter<LogbookState> emit,
  ) async {
    emit(const LogbookLoading());
    final result = await _getLogbookDetailByIdUseCase.call(event.detailId);
    result.fold(
      (failure) => emit(LogbookError(failure.message)),
      (detail) => emit(LogbookDetailByIdLoaded(detail)),
    );
  }
}
