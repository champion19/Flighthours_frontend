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

  Future<void> _onFetchEmployeeFlights(
    FetchEmployeeFlights event,
    Emitter<FlightState> emit,
  ) async {
    emit(const FlightLoading());
    try {
      final flights = await _dataSource.getEmployeeFlights();
      emit(FlightListLoaded(flights));
    } catch (e) {
      emit(FlightError('Error loading flights: $e'));
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
      emit(FlightError('Error loading flight detail: $e'));
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
      emit(FlightError('Error fetching logbook: $e'));
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
      emit(FlightError('Error creating flight: $e'));
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
      emit(FlightError('Error updating flight: $e'));
    }
  }
}
