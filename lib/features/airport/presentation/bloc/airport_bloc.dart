import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';

/// BLoC for managing airport-related state
class AirportBloc extends Bloc<AirportEvent, AirportState> {
  final ListAirportUseCase _listAirportUseCase;
  final GetAirportByIdUseCase _getAirportByIdUseCase;
  final ActivateAirportUseCase _activateAirportUseCase;
  final DeactivateAirportUseCase _deactivateAirportUseCase;

  AirportBloc({
    ListAirportUseCase? listAirportUseCase,
    GetAirportByIdUseCase? getAirportByIdUseCase,
    ActivateAirportUseCase? activateAirportUseCase,
    DeactivateAirportUseCase? deactivateAirportUseCase,
  }) : _listAirportUseCase =
           listAirportUseCase ?? InjectorApp.resolve<ListAirportUseCase>(),
       _getAirportByIdUseCase =
           getAirportByIdUseCase ??
           InjectorApp.resolve<GetAirportByIdUseCase>(),
       _activateAirportUseCase =
           activateAirportUseCase ??
           InjectorApp.resolve<ActivateAirportUseCase>(),
       _deactivateAirportUseCase =
           deactivateAirportUseCase ??
           InjectorApp.resolve<DeactivateAirportUseCase>(),
       super(AirportInitial()) {
    on<FetchAirports>(_onFetchAirports);
    on<FetchAirportById>(_onFetchAirportById);
    on<ActivateAirport>(_onActivateAirport);
    on<DeactivateAirport>(_onDeactivateAirport);
  }

  Future<void> _onFetchAirports(
    FetchAirports event,
    Emitter<AirportState> emit,
  ) async {
    emit(AirportLoading());

    final result = await _listAirportUseCase.call();
    result.fold(
      (failure) => emit(AirportError(failure.message)),
      (airports) => emit(AirportSuccess(airports)),
    );
  }

  Future<void> _onFetchAirportById(
    FetchAirportById event,
    Emitter<AirportState> emit,
  ) async {
    final result = await _getAirportByIdUseCase.call(event.airportId);
    result.fold(
      (_) {}, // Silently fail
      (airport) => emit(AirportDetailSuccess(airport)),
    );
  }

  Future<void> _onActivateAirport(
    ActivateAirport event,
    Emitter<AirportState> emit,
  ) async {
    emit(AirportLoading());

    final result = await _activateAirportUseCase.call(event.airportId);
    result.fold((failure) => emit(AirportError(failure.message)), (response) {
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: true));
      } else {
        emit(AirportError(response.message));
      }
    });
  }

  Future<void> _onDeactivateAirport(
    DeactivateAirport event,
    Emitter<AirportState> emit,
  ) async {
    emit(AirportLoading());

    final result = await _deactivateAirportUseCase.call(event.airportId);
    result.fold((failure) => emit(AirportError(failure.message)), (response) {
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: false));
      } else {
        emit(AirportError(response.message));
      }
    });
  }
}
