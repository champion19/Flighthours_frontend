import 'package:flight_hours_app/features/register/data/models/register_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

abstract class RegisterRepository {
  Future<RegisterModel> registerEmployee(EmployeeEntityRegister employee);

}
