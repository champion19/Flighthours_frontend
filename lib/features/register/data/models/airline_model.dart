import 'dart:convert';

import 'package:flight_hours_app/features/register/domain/entities/airline_entity.dart';

List<AirlineModel> airlineModelFromMap(String str) => List<AirlineModel>.from(
  json.decode(str).map((x) => AirlineModel.fromMap(x)),
);

String airlineModelToMap(List<AirlineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class AirlineModel extends AirlineEntity {
  @override
  final String id;
  @override
  final String name;

  AirlineModel({required this.id, required this.name})
    : super(id: id, name: name);

  factory AirlineModel.fromMap(Map<String, dynamic> json) =>
      AirlineModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}
