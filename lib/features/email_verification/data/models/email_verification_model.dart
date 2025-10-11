import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

class EmailVerificationModel extends EmailEntity {
  @override
  final bool emailconfirmed;
  factory EmailVerificationModel.fromMap(Map<String, dynamic> json) =>
      EmailVerificationModel(emailconfirmed: json["emailconfirmed"]);

  EmailVerificationModel({required this.emailconfirmed}) : super(emailconfirmed: false);
}
//dominio es el centro de la apicacion, lo que va a usar el datasource

