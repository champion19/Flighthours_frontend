
import 'dart:convert';

import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
List<AirlineModel> airlineModelFromMap(String str) => List<AirlineModel>.from(
  json.decode(str).map((x) => AirlineModel.fromJson(x)),
);

String airlineModelToMap(List<AirlineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AirlineModel extends AirlineEntity {
  const AirlineModel({required super.id, required super.name});

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
