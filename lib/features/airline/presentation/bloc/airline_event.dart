
import 'package:equatable/equatable.dart';

abstract class AirlineEvent extends Equatable {
  const AirlineEvent();

  @override
  List<Object> get props => [];
}

class FetchAirlines extends AirlineEvent {}
