class AirlineEntity {
  final String id;
  final String name;

  AirlineEntity({required this.id, required this.name});

  AirlineEntity copyWith({String? id, String? name}) =>
      AirlineEntity(id: id ?? this.id, name: name ?? this.name);
}
