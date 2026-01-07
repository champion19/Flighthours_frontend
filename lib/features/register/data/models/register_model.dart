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
  final String? password;

  @override
  final bool? emailConfirmed;

  @override
  final String idNumber;

  @override
  final String? bp;

  @override
  final String fechaInicio;

  @override
  final String fechaFin;

  @override
  final bool? vigente;

  @override
  final String? airline;

  RegisterModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailConfirmed,
    required this.idNumber,
    this.bp,
    required this.fechaInicio,
    required this.fechaFin,
    this.vigente,
    this.password,
    this.airline,
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

  factory RegisterModel.fromMap(Map<String, dynamic> json) {
    // Parse airline - keep null if not present or empty
    String? airlineValue = json["airline"];
    if (airlineValue != null && airlineValue.isEmpty) {
      airlineValue = null;
    }

    // Parse bp - keep null if not present or empty
    String? bpValue = json["bp"];
    if (bpValue != null && bpValue.isEmpty) {
      bpValue = null;
    }

    return RegisterModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      airline: airlineValue,
      email: json["email"] ?? '',
      password: json["password"],
      emailConfirmed: json["emailConfirmed"] ?? false,
      idNumber: json["identification_number"] ?? '',
      bp: bpValue,
      fechaInicio: json["start_date"] ?? DateTime.now().toIso8601String(),
      fechaFin: json["end_date"] ?? DateTime.now().toIso8601String(),
      vigente: json["active"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
      "idNumber": idNumber,
      "fechaInicio": fechaInicio,
      "fechaFin": fechaFin,
    };

    // Only include optional fields if they have values
    if (password != null && password!.isNotEmpty) {
      map["password"] = password;
    }
    if (emailConfirmed != null) {
      map["emailConfirmed"] = emailConfirmed;
    }
    if (bp != null && bp!.isNotEmpty) {
      map["bp"] = bp;
    }
    if (airline != null && airline!.isNotEmpty) {
      map["airline"] = airline;
    }
    if (vigente != null) {
      map["vigente"] = vigente;
    }

    return map;
  }
}
