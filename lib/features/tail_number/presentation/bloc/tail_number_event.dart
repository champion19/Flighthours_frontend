import 'package:equatable/equatable.dart';

/// Events for the Tail Number BLoC
abstract class TailNumberEvent extends Equatable {
  const TailNumberEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tail numbers
class LoadAllTailNumbers extends TailNumberEvent {}

/// Event to search a tail number by its ID
class SearchTailNumber extends TailNumberEvent {
  final String id;

  const SearchTailNumber(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to select a tail number (fetches aircraft model for engine info)
class SelectTailNumber extends TailNumberEvent {
  final String id;

  const SelectTailNumber(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to create a new tail number (aircraft registration)
class CreateTailNumber extends TailNumberEvent {
  final String tailNumber;
  final String aircraftModelId;
  final String airlineId;

  const CreateTailNumber({
    required this.tailNumber,
    required this.aircraftModelId,
    required this.airlineId,
  });

  @override
  List<Object?> get props => [tailNumber, aircraftModelId, airlineId];
}

/// Event to reset the tail number state
class ResetTailNumber extends TailNumberEvent {}
