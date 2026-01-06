import 'package:flight_hours_app/features/register/data/datasources/register_datasource.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterDatasource registerDatasource;

  RegisterRepositoryImpl(this.registerDatasource);

  @override
  Future<RegisterResponseModel> registerEmployee(
    EmployeeEntityRegister employee,
  ) async {
    return await registerDatasource.registerEmployee(employee);
  }
}
