import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';

/// BLoC for managing airline-related state
class AirlineBloc extends Bloc<AirlineEvent, AirlineState> {
  final ListAirlineUseCase _listAirlineUseCase;
  final GetAirlineByIdUseCase _getAirlineByIdUseCase;
  final ActivateAirlineUseCase _activateAirlineUseCase;
  final DeactivateAirlineUseCase _deactivateAirlineUseCase;

  AirlineBloc({
    ListAirlineUseCase? listAirlineUseCase,
    GetAirlineByIdUseCase? getAirlineByIdUseCase,
    ActivateAirlineUseCase? activateAirlineUseCase,
    DeactivateAirlineUseCase? deactivateAirlineUseCase,
  }) : _listAirlineUseCase =
           listAirlineUseCase ?? InjectorApp.resolve<ListAirlineUseCase>(),
       _getAirlineByIdUseCase =
           getAirlineByIdUseCase ??
           InjectorApp.resolve<GetAirlineByIdUseCase>(),
       _activateAirlineUseCase =
           activateAirlineUseCase ??
           InjectorApp.resolve<ActivateAirlineUseCase>(),
       _deactivateAirlineUseCase =
           deactivateAirlineUseCase ??
           InjectorApp.resolve<DeactivateAirlineUseCase>(),
       super(AirlineInitial()) {
    on<FetchAirlines>(_onFetchAirlines);
    on<FetchAirlineById>(_onFetchAirlineById);
    on<ActivateAirline>(_onActivateAirline);
    on<DeactivateAirline>(_onDeactivateAirline);
  }

  Future<void> _onFetchAirlines(
    FetchAirlines event,
    Emitter<AirlineState> emit,
  ) async {
    emit(AirlineLoading());

    final result = await _listAirlineUseCase.call();
    result.fold(
      (failure) => emit(AirlineError(failure.message)),
      (airlines) => emit(AirlineSuccess(airlines)),
    );
  }

  Future<void> _onFetchAirlineById(
    FetchAirlineById event,
    Emitter<AirlineState> emit,
  ) async {
    final result = await _getAirlineByIdUseCase.call(event.airlineId);
    result.fold(
      (_) {}, // Silently fail
      (airline) => emit(AirlineDetailSuccess(airline)),
    );
  }

  Future<void> _onActivateAirline(
    ActivateAirline event,
    Emitter<AirlineState> emit,
  ) async {
    emit(AirlineStatusUpdating(airlineId: event.airlineId));

    final result = await _activateAirlineUseCase.call(event.airlineId);
    result.fold(
      (failure) => emit(
        AirlineStatusUpdateError(
          message: failure.message,
          code: failure.code ?? 'UNKNOWN_ERROR',
        ),
      ),
      (response) {
        if (response.success) {
          emit(
            AirlineStatusUpdateSuccess(
              message: response.message,
              code: response.code,
              newStatus: response.status,
            ),
          );
        } else {
          emit(
            AirlineStatusUpdateError(
              message: response.message,
              code: response.code,
            ),
          );
        }
      },
    );
  }

  Future<void> _onDeactivateAirline(
    DeactivateAirline event,
    Emitter<AirlineState> emit,
  ) async {
    emit(AirlineStatusUpdating(airlineId: event.airlineId));

    final result = await _deactivateAirlineUseCase.call(event.airlineId);
    result.fold(
      (failure) => emit(
        AirlineStatusUpdateError(
          message: failure.message,
          code: failure.code ?? 'UNKNOWN_ERROR',
        ),
      ),
      (response) {
        if (response.success) {
          emit(
            AirlineStatusUpdateSuccess(
              message: response.message,
              code: response.code,
              newStatus: response.status,
            ),
          );
        } else {
          emit(
            AirlineStatusUpdateError(
              message: response.message,
              code: response.code,
            ),
          );
        }
      },
    );
  }
}
