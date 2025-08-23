import 'dart:convert';

import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

class RegisterModel extends EmployeeEntityRegister {
  @override
  final String id;

  @override
  final String name;

  @override
  final String email;

  @override
  final String password;

  @override
  final bool emailConfirmed;

  @override
  final String idNumber;

  @override
  final int bp;

  @override
  final String fechaInicio;

  @override
  final String fechaFin;
  @override
  final String vigente;

  @override
  final String airline;

  RegisterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailConfirmed,
    required this.idNumber,
    required this.bp,
    required this.fechaInicio,
    required this.fechaFin,
    required this.vigente,
    required this.password,
    required this.airline,
  }) : super(
         id: id,
         name: name,
         email: email,
         emailConfirmed: emailConfirmed,
         idNumber: idNumber,
         bp: bp,
         fechaInicio: fechaInicio,
         fechaFin: fechaFin,
         vigente: vigente,
         password: password,
         airline: airline,
       );

  factory RegisterModel.fromJson(String str) =>
      RegisterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterModel.fromMap(Map<String, dynamic> json) => RegisterModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    emailConfirmed: json["emailConfirmed"],
    idNumber: json["idNumber"],
    bp: json["bp"],
    fechaInicio: json["fechaInicio"],
    fechaFin: json["fechaFin"],
    vigente: json["vigente"],
    airline: json["airline"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "emailConfirmed": emailConfirmed,
    "idNumber": idNumber,
    "bp": bp,
    "fechaInicio": fechaInicio,
    "fechaFin": fechaFin,
    "vigente": vigente,
  };
}
