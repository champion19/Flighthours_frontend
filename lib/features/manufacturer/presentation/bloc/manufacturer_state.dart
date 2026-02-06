import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';

abstract class ManufacturerState extends Equatable {
  const ManufacturerState();

  @override
  List<Object?> get props => [];
}

class ManufacturerInitial extends ManufacturerState {}

class ManufacturerLoading extends ManufacturerState {}

class ManufacturerSuccess extends ManufacturerState {
  final List<ManufacturerEntity> manufacturers;

  const ManufacturerSuccess({required this.manufacturers});

  @override
  List<Object?> get props => [manufacturers];
}

class ManufacturerDetailSuccess extends ManufacturerState {
  final ManufacturerEntity manufacturer;

  const ManufacturerDetailSuccess({required this.manufacturer});

  @override
  List<Object?> get props => [manufacturer];
}

class ManufacturerError extends ManufacturerState {
  final String message;

  const ManufacturerError({required this.message});

  @override
  List<Object?> get props => [message];
}
