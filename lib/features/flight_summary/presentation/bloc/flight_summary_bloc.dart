import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/features/flight_summary/data/datasources/flight_summary_remote_data_source.dart';
import 'package:flight_hours_app/features/flight_summary/data/repositories/flight_summary_repository_impl.dart';
import 'package:flight_hours_app/features/flight_summary/domain/usecases/get_flight_hours_summary_use_case.dart';
import 'package:flight_hours_app/features/flight_summary/domain/usecases/get_flight_alerts_use_case.dart';
import 'package:flight_hours_app/features/flight_summary/domain/usecases/get_recent_flights_use_case.dart';
import 'package:flight_hours_app/features/flight_summary/presentation/bloc/flight_summary_event.dart';
import 'package:flight_hours_app/features/flight_summary/presentation/bloc/flight_summary_state.dart';

class FlightSummaryBloc extends Bloc<FlightSummaryEvent, FlightSummaryState> {
  final GetFlightHoursSummaryUseCase _getFlightHoursSummary;
  final GetFlightAlertsUseCase _getFlightAlerts;
  final GetRecentFlightsUseCase _getRecentFlights;

  FlightSummaryBloc({
    GetFlightHoursSummaryUseCase? getFlightHoursSummary,
    GetFlightAlertsUseCase? getFlightAlerts,
    GetRecentFlightsUseCase? getRecentFlights,
  }) : _getFlightHoursSummary =
           getFlightHoursSummary ??
           GetFlightHoursSummaryUseCase(
             repository: FlightSummaryRepositoryImpl(
               remoteDataSource: FlightSummaryRemoteDataSourceImpl(),
             ),
           ),
       _getFlightAlerts =
           getFlightAlerts ??
           GetFlightAlertsUseCase(
             repository: FlightSummaryRepositoryImpl(
               remoteDataSource: FlightSummaryRemoteDataSourceImpl(),
             ),
           ),
       _getRecentFlights =
           getRecentFlights ??
           GetRecentFlightsUseCase(
             repository: FlightSummaryRepositoryImpl(
               remoteDataSource: FlightSummaryRemoteDataSourceImpl(),
             ),
           ),
       super(FlightSummaryInitial()) {
    on<LoadOverallSummary>(_onLoadOverallSummary);
    on<LoadFlightHoursSummary>(_onLoadFlightHoursSummary);
    on<LoadFlightAlerts>(_onLoadFlightAlerts);
    on<LoadRecentFlights>(_onLoadRecentFlights);
  }

  /// Overall summary — always annual, never filtered.
  /// Used exclusively by the Home page donut chart.
  Future<void> _onLoadOverallSummary(
    LoadOverallSummary event,
    Emitter<FlightSummaryState> emit,
  ) async {
    emit(OverallSummaryLoading());
    try {
      final now = DateTime.now();
      final referenceDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final response = await _getFlightHoursSummary(
        referenceDate: referenceDate,
        period: 'annual',
      );
      if (response.success && response.data != null) {
        emit(OverallSummarySuccess(data: response.data!));
      } else {
        emit(OverallSummaryError(message: response.message));
      }
    } catch (e) {
      emit(OverallSummaryError(message: e.toString()));
    }
  }

  /// Filtered summary — used by Alerts page stat cards.
  /// Period and referenceDate come from the user's filter selection.
  Future<void> _onLoadFlightHoursSummary(
    LoadFlightHoursSummary event,
    Emitter<FlightSummaryState> emit,
  ) async {
    emit(FlightHoursSummaryLoading());
    try {
      final response = await _getFlightHoursSummary(
        referenceDate: event.referenceDate,
        period: event.period,
      );
      if (response.success && response.data != null) {
        emit(FlightHoursSummarySuccess(data: response.data!));
      } else {
        emit(FlightHoursSummaryError(message: response.message));
      }
    } catch (e) {
      emit(FlightHoursSummaryError(message: e.toString()));
    }
  }

  Future<void> _onLoadFlightAlerts(
    LoadFlightAlerts event,
    Emitter<FlightSummaryState> emit,
  ) async {
    emit(FlightAlertsLoading());
    try {
      final response = await _getFlightAlerts();
      if (response.success && response.data != null) {
        emit(FlightAlertsSuccess(alerts: response.data!.alerts));
      } else {
        emit(FlightAlertsError(message: response.message));
      }
    } catch (e) {
      emit(FlightAlertsError(message: e.toString()));
    }
  }

  Future<void> _onLoadRecentFlights(
    LoadRecentFlights event,
    Emitter<FlightSummaryState> emit,
  ) async {
    emit(RecentFlightsLoading());
    try {
      final response = await _getRecentFlights();
      if (response.success) {
        emit(RecentFlightsSuccess(flights: response.data));
      } else {
        emit(RecentFlightsError(message: response.message));
      }
    } catch (e) {
      emit(RecentFlightsError(message: e.toString()));
    }
  }
}
