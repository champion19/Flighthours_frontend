import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';

class AirlineBloc extends Bloc<AirlineEvent, AirlineState> {
  AirlineBloc() : super(AirlineInitial()) {
    final listAirlineUseCase = InjectorApp.resolve<ListAirlineUseCase>();
    final getAirlineByIdUseCase = InjectorApp.resolve<GetAirlineByIdUseCase>();
    final activateAirlineUseCase =
        InjectorApp.resolve<ActivateAirlineUseCase>();
    final deactivateAirlineUseCase =
        InjectorApp.resolve<DeactivateAirlineUseCase>();

    on<FetchAirlines>(
      (event, emit) => _onFetchAirlines(event, emit, listAirlineUseCase),
    );
    on<FetchAirlineById>(
      (event, emit) => _onFetchAirlineById(event, emit, getAirlineByIdUseCase),
    );
    on<ActivateAirline>(
      (event, emit) => _onActivateAirline(event, emit, activateAirlineUseCase),
    );
    on<DeactivateAirline>(
      (event, emit) =>
          _onDeactivateAirline(event, emit, deactivateAirlineUseCase),
    );
  }

  Future<void> _onFetchAirlines(
    FetchAirlines event,
    Emitter<AirlineState> emit,
    ListAirlineUseCase listAirlineUseCase,
  ) async {
    emit(AirlineLoading());

    try {
      final airlines = await listAirlineUseCase.call();
      emit(AirlineSuccess(airlines));
    } catch (e) {
      emit(AirlineError(e.toString()));
    }
  }

  Future<void> _onFetchAirlineById(
    FetchAirlineById event,
    Emitter<AirlineState> emit,
    GetAirlineByIdUseCase getAirlineByIdUseCase,
  ) async {
    try {
      final airline = await getAirlineByIdUseCase.call(event.airlineId);
      if (airline != null) {
        emit(AirlineDetailSuccess(airline));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }

  Future<void> _onActivateAirline(
    ActivateAirline event,
    Emitter<AirlineState> emit,
    ActivateAirlineUseCase activateAirlineUseCase,
  ) async {
    emit(AirlineStatusUpdating(airlineId: event.airlineId));

    try {
      final response = await activateAirlineUseCase.call(event.airlineId);

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
    } catch (e) {
      emit(
        AirlineStatusUpdateError(message: e.toString(), code: 'UNKNOWN_ERROR'),
      );
    }
  }

  Future<void> _onDeactivateAirline(
    DeactivateAirline event,
    Emitter<AirlineState> emit,
    DeactivateAirlineUseCase deactivateAirlineUseCase,
  ) async {
    emit(AirlineStatusUpdating(airlineId: event.airlineId));

    try {
      final response = await deactivateAirlineUseCase.call(event.airlineId);

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
    } catch (e) {
      emit(
        AirlineStatusUpdateError(message: e.toString(), code: 'UNKNOWN_ERROR'),
      );
    }
  }
}
