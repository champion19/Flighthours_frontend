import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/get_aircraft_model_by_id_use_case.dart';
import 'package:flight_hours_app/features/tail_number/domain/usecases/get_tail_number_by_plate_use_case.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_event.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_state.dart';

/// BLoC for Tail Number lookup (HU31 + HU34)
///
/// Flow:
/// 1. User types plate number (e.g. "CC-BAC")
/// 2. SearchTailNumber → GET /tail-numbers/:plate
/// 3. If found → chains GET /aircraft-models/:aircraftModelId
/// 4. Emits TailNumberSuccess with plate + aircraft model data
/// 5. On error → emits TailNumberError with backend message
class TailNumberBloc extends Bloc<TailNumberEvent, TailNumberState> {
  final GetTailNumberByPlateUseCase _getTailNumberByPlateUseCase;
  final GetAircraftModelByIdUseCase _getAircraftModelByIdUseCase;

  TailNumberBloc()
    : _getTailNumberByPlateUseCase =
          InjectorApp.resolve<GetTailNumberByPlateUseCase>(),
      _getAircraftModelByIdUseCase =
          InjectorApp.resolve<GetAircraftModelByIdUseCase>(),
      super(TailNumberInitial()) {
    on<SearchTailNumber>(_onSearch);
    on<ResetTailNumber>(_onReset);
  }

  /// Search by plate → chain aircraft model fetch
  Future<void> _onSearch(
    SearchTailNumber event,
    Emitter<TailNumberState> emit,
  ) async {
    emit(TailNumberLoading());

    // Step 1: GET /tail-numbers/:plate
    final plateResult = await _getTailNumberByPlateUseCase.call(event.id);

    await plateResult.fold(
      (failure) async => emit(TailNumberError(failure.message)),
      (plate) async {
        // Step 2: GET /aircraft-models/:aircraftModelId (HU34)
        if (plate.aircraftModelId != null &&
            plate.aircraftModelId!.isNotEmpty) {
          final modelResult = await _getAircraftModelByIdUseCase.call(
            plate.aircraftModelId!,
          );
          modelResult.fold(
            (_) => emit(
              TailNumberSuccess(plate),
            ), // Show plate even if model fails
            (aircraftModel) =>
                emit(TailNumberSuccess(plate, aircraftModel: aircraftModel)),
          );
        } else {
          emit(TailNumberSuccess(plate));
        }
      },
    );
  }

  void _onReset(ResetTailNumber event, Emitter<TailNumberState> emit) {
    emit(TailNumberInitial());
  }
}
