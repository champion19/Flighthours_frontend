import 'dart:convert';

import 'package:flight_hours_app/features/login/domain/entities/EmployeeEntity.dart';

class EmployeeModel extends EmployeeEntity {
    @override
  final String id;
    @override
  final String name;
    @override
  final int age;
    @override
  final String email;
    @override
  final String token;

    EmployeeModel({
        required this.id,
        required this.name,
        required this.age,
        required this.email,
        required this.token,
    }) : super(id:id, name: name, age: age, email: email, token: token);

    factory EmployeeModel.fromJson(String str) => EmployeeModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EmployeeModel.fromMap(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        email: json["email"],
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "age": age,
        "email": email,
        "token": token,
    };
}
