import 'package:equatable/equatable.dart';

abstract class ManufacturerEvent extends Equatable {
  const ManufacturerEvent();

  @override
  List<Object?> get props => [];
}

class FetchManufacturers extends ManufacturerEvent {}

class GetManufacturerDetail extends ManufacturerEvent {
  final String manufacturerId;

  const GetManufacturerDetail({required this.manufacturerId});

  @override
  List<Object?> get props => [manufacturerId];
}
