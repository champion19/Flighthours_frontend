import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/get_aircraft_model_by_id_use_case.dart';
import 'package:flight_hours_app/features/license_plate/domain/usecases/get_license_plate_by_id_use_case.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_event.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_state.dart';

/// BLoC for License Plate lookup (HU31 + HU34)
///
/// Flow:
/// 1. User types plate number (e.g. "CC-BAC")
/// 2. SearchLicensePlate → GET /license-plates/:plate
/// 3. If found → chains GET /aircraft-models/:aircraftModelId
/// 4. Emits LicensePlateSuccess with plate + aircraft model data
/// 5. On error → emits LicensePlateError with backend message
class LicensePlateBloc extends Bloc<LicensePlateEvent, LicensePlateState> {
  final GetLicensePlateByPlateUseCase _getLicensePlateByPlateUseCase;
  final GetAircraftModelByIdUseCase _getAircraftModelByIdUseCase;

  LicensePlateBloc()
    : _getLicensePlateByPlateUseCase =
          InjectorApp.resolve<GetLicensePlateByPlateUseCase>(),
      _getAircraftModelByIdUseCase =
          InjectorApp.resolve<GetAircraftModelByIdUseCase>(),
      super(LicensePlateInitial()) {
    on<SearchLicensePlate>(_onSearch);
    on<ResetLicensePlate>(_onReset);
  }

  /// Search by plate → chain aircraft model fetch
  Future<void> _onSearch(
    SearchLicensePlate event,
    Emitter<LicensePlateState> emit,
  ) async {
    emit(LicensePlateLoading());

    // Step 1: GET /license-plates/:plate
    final plateResult = await _getLicensePlateByPlateUseCase.call(event.id);

    await plateResult.fold(
      (failure) async => emit(LicensePlateError(failure.message)),
      (plate) async {
        // Step 2: GET /aircraft-models/:aircraftModelId (HU34)
        if (plate.aircraftModelId != null &&
            plate.aircraftModelId!.isNotEmpty) {
          final modelResult = await _getAircraftModelByIdUseCase.call(
            plate.aircraftModelId!,
          );
          modelResult.fold(
            (_) => emit(
              LicensePlateSuccess(plate),
            ), // Show plate even if model fails
            (aircraftModel) =>
                emit(LicensePlateSuccess(plate, aircraftModel: aircraftModel)),
          );
        } else {
          emit(LicensePlateSuccess(plate));
        }
      },
    );
  }

  void _onReset(ResetLicensePlate event, Emitter<LicensePlateState> emit) {
    emit(LicensePlateInitial());
  }
}
