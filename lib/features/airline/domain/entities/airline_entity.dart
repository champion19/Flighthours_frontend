
import 'package:equatable/equatable.dart';

class AirlineEntity extends Equatable {
  final String id;
  final String name;

  const AirlineEntity({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
