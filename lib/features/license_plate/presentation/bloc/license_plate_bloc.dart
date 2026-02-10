import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    try {
      // Step 1: GET /license-plates/:plate
      final plate = await _getLicensePlateByPlateUseCase.call(event.id);
      debugPrint('✅ LicensePlateBloc: Found ${plate.licensePlate}');

      // Step 2: GET /aircraft-models/:aircraftModelId (HU34)
      if (plate.aircraftModelId != null && plate.aircraftModelId!.isNotEmpty) {
        try {
          final aircraftModel = await _getAircraftModelByIdUseCase.call(
            plate.aircraftModelId!,
          );
          debugPrint(
            '✅ LicensePlateBloc: Aircraft model: ${aircraftModel.name}, '
            'engine: ${aircraftModel.engineName}',
          );
          emit(LicensePlateSuccess(plate, aircraftModel: aircraftModel));
        } catch (e) {
          debugPrint('⚠️ LicensePlateBloc: Aircraft model failed: $e');
          // Still show plate data even if aircraft model fails
          emit(LicensePlateSuccess(plate));
        }
      } else {
        emit(LicensePlateSuccess(plate));
      }
    } on DioException catch (e) {
      debugPrint('❌ LicensePlateBloc DioError: ${e.response?.statusCode}');
      final data = e.response?.data;
      String message = 'Error searching license plate';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      emit(LicensePlateError(message));
    } catch (e) {
      debugPrint('❌ LicensePlateBloc Error: $e');
      emit(LicensePlateError(e.toString()));
    }
  }

  void _onReset(ResetLicensePlate event, Emitter<LicensePlateState> emit) {
    emit(LicensePlateInitial());
  }
}
