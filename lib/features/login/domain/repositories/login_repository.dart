import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginEmployee(String email, String password);
  Future<void> logoutEmployee();
}
