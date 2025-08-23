import 'package:flight_hours_app/features/login/data/models/login_model.dart';

abstract class LoginRepository {
  Future<EmployeeModel> loginEmployee(String email, String password);
  Future<void> logoutEmployee();
}
