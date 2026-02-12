import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/features/flight/data/datasources/flight_remote_data_source.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';

/// BLoC for managing flight operations
class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final FlightRemoteDataSource _dataSource;

  FlightBloc({FlightRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FlightRemoteDataSourceImpl(),
      super(const FlightInitial()) {
    on<FetchEmployeeFlights>(_onFetchEmployeeFlights);
    on<LoadFlightDetail>(_onLoadFlightDetail);
    on<FetchLogbookId>(_onFetchLogbookId);
    on<CreateFlight>(_onCreateFlight);
    on<UpdateFlight>(_onUpdateFlight);
  }

  /// Extracts the backend error message from a DioException,
  /// falling back to a generic message if unavailable.
  String _extractErrorMessage(dynamic e, String fallback) {
    if (e is DioException && e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  Future<void> _onFetchEmployeeFlights(
    FetchEmployeeFlights event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final flights = await _dataSource.getEmployeeFlights();
      emit(FlightListLoaded(flights));
    } catch (e) {
      emit(FlightError(_extractErrorMessage(e, 'Error loading flights')));
    }
  }

  Future<void> _onLoadFlightDetail(
    LoadFlightDetail event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final flight = await _dataSource.getFlightById(event.flightId);
      if (flight != null) {
        emit(FlightDetailLoaded(flight));
      } else {
        emit(const FlightError('Flight not found'));
      }
    } catch (e) {
      emit(FlightError(_extractErrorMessage(e, 'Error loading flight detail')));
    }
  }

  Future<void> _onFetchLogbookId(
    FetchLogbookId event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final logbookId = await _dataSource.getEmployeeLogbookId();
      if (logbookId != null) {
        emit(LogbookIdLoaded(logbookId));
      } else {
        emit(const FlightError('No logbook found for this employee'));
      }
    } catch (e) {
      emit(FlightError(_extractErrorMessage(e, 'Error fetching logbook')));
    }
  }

  Future<void> _onCreateFlight(
    CreateFlight event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final flight = await _dataSource.createFlight(
        dailyLogbookId: event.dailyLogbookId,
        data: event.data,
      );
      emit(FlightCreated(flight));
    } catch (e) {
      emit(FlightError(_extractErrorMessage(e, 'Error creating flight')));
    }
  }

  Future<void> _onUpdateFlight(
    UpdateFlight event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final flight = await _dataSource.updateFlight(
        id: event.flightId,
        data: event.data,
      );
      emit(FlightUpdated(flight));
    } catch (e) {
      emit(FlightError(_extractErrorMessage(e, 'Error updating flight')));
    }
  }
}
