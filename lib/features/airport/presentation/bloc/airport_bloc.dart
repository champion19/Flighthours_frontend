import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';

/// BLoC for managing airport-related state
///
/// Supports dependency injection for testing:
/// - [listAirportUseCase] for listing airports
/// - [getAirportByIdUseCase] for fetching airport details
/// - [activateAirportUseCase] for activating airports
/// - [deactivateAirportUseCase] for deactivating airports
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

    try {
      final airports = await _listAirportUseCase.call();
      emit(AirportSuccess(airports));
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }

  Future<void> _onFetchAirportById(
    FetchAirportById event,
    Emitter<AirportState> emit,
  ) async {
    try {
      final airport = await _getAirportByIdUseCase.call(event.airportId);
      if (airport != null) {
        emit(AirportDetailSuccess(airport));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }

  Future<void> _onActivateAirport(
    ActivateAirport event,
    Emitter<AirportState> emit,
  ) async {
    emit(AirportLoading());

    try {
      final response = await _activateAirportUseCase.call(event.airportId);
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: true));
      } else {
        emit(AirportError(response.message));
      }
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }

  Future<void> _onDeactivateAirport(
    DeactivateAirport event,
    Emitter<AirportState> emit,
  ) async {
    emit(AirportLoading());

    try {
      final response = await _deactivateAirportUseCase.call(event.airportId);
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: false));
      } else {
        emit(AirportError(response.message));
      }
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }
}
