import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/activate_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/deactivate_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/get_aircraft_models_by_family_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/list_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_event.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_state.dart';

/// BLoC for managing aircraft model-related state
///
/// Supports dependency injection for testing:
/// - [listAircraftModelUseCase] for listing aircraft models
/// - [getAircraftModelsByFamilyUseCase] for fetching models by family
/// - [activateAircraftModelUseCase] for activating aircraft models
/// - [deactivateAircraftModelUseCase] for deactivating aircraft models
class AircraftModelBloc extends Bloc<AircraftModelEvent, AircraftModelState> {
  final ListAircraftModelUseCase _listAircraftModelUseCase;
  final GetAircraftModelsByFamilyUseCase _getAircraftModelsByFamilyUseCase;
  final ActivateAircraftModelUseCase _activateAircraftModelUseCase;
  final DeactivateAircraftModelUseCase _deactivateAircraftModelUseCase;

  AircraftModelBloc({
    ListAircraftModelUseCase? listAircraftModelUseCase,
    GetAircraftModelsByFamilyUseCase? getAircraftModelsByFamilyUseCase,
    ActivateAircraftModelUseCase? activateAircraftModelUseCase,
    DeactivateAircraftModelUseCase? deactivateAircraftModelUseCase,
  }) : _listAircraftModelUseCase =
           listAircraftModelUseCase ??
           InjectorApp.resolve<ListAircraftModelUseCase>(),
       _getAircraftModelsByFamilyUseCase =
           getAircraftModelsByFamilyUseCase ??
           InjectorApp.resolve<GetAircraftModelsByFamilyUseCase>(),
       _activateAircraftModelUseCase =
           activateAircraftModelUseCase ??
           InjectorApp.resolve<ActivateAircraftModelUseCase>(),
       _deactivateAircraftModelUseCase =
           deactivateAircraftModelUseCase ??
           InjectorApp.resolve<DeactivateAircraftModelUseCase>(),
       super(AircraftModelInitial()) {
    on<FetchAircraftModels>(_onFetchAircraftModels);
    on<FetchAircraftModelsByFamily>(_onFetchAircraftModelsByFamily);
    on<ActivateAircraftModel>(_onActivateAircraftModel);
    on<DeactivateAircraftModel>(_onDeactivateAircraftModel);
  }

  Future<void> _onFetchAircraftModels(
    FetchAircraftModels event,
    Emitter<AircraftModelState> emit,
  ) async {
    emit(AircraftModelLoading());

    try {
      final aircraftModels = await _listAircraftModelUseCase.call();
      emit(AircraftModelSuccess(aircraftModels));
    } catch (e) {
      emit(AircraftModelError(e.toString()));
    }
  }

  Future<void> _onFetchAircraftModelsByFamily(
    FetchAircraftModelsByFamily event,
    Emitter<AircraftModelState> emit,
  ) async {
    emit(AircraftModelLoading());

    try {
      final aircraftModels = await _getAircraftModelsByFamilyUseCase.call(
        event.family,
      );
      emit(AircraftModelsByFamilySuccess(aircraftModels, family: event.family));
    } catch (e) {
      emit(AircraftModelError(e.toString()));
    }
  }

  Future<void> _onActivateAircraftModel(
    ActivateAircraftModel event,
    Emitter<AircraftModelState> emit,
  ) async {
    emit(AircraftModelLoading());

    try {
      final response = await _activateAircraftModelUseCase.call(
        event.aircraftModelId,
      );
      if (response.success) {
        emit(AircraftModelStatusUpdateSuccess(response, isActivation: true));
      } else {
        emit(AircraftModelError(response.message));
      }
    } catch (e) {
      emit(AircraftModelError(e.toString()));
    }
  }

  Future<void> _onDeactivateAircraftModel(
    DeactivateAircraftModel event,
    Emitter<AircraftModelState> emit,
  ) async {
    emit(AircraftModelLoading());

    try {
      final response = await _deactivateAircraftModelUseCase.call(
        event.aircraftModelId,
      );
      if (response.success) {
        emit(AircraftModelStatusUpdateSuccess(response, isActivation: false));
      } else {
        emit(AircraftModelError(response.message));
      }
    } catch (e) {
      emit(AircraftModelError(e.toString()));
    }
  }
}
