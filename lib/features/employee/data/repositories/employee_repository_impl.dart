import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Implementation of the employee repository
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource _dataSource =
      InjectorApp.resolve<EmployeeRemoteDataSource>();

  @override
  Future<EmployeeResponseModel> getCurrentEmployee() {
    return _dataSource.getCurrentEmployee();
  }

  @override
  Future<EmployeeUpdateResponseModel> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  ) {
    return _dataSource.updateCurrentEmployee(request);
  }

  @override
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequest request,
  ) {
    return _dataSource.changePassword(request);
  }

  @override
  Future<DeleteEmployeeResponseModel> deleteCurrentEmployee() {
    return _dataSource.deleteCurrentEmployee();
  }

  @override
  Future<EmployeeAirlineResponseModel> getEmployeeAirline() {
    return _dataSource.getEmployeeAirline();
  }

  @override
  Future<EmployeeAirlineResponseModel> updateEmployeeAirline(
    EmployeeAirlineUpdateRequest request,
  ) {
    return _dataSource.updateEmployeeAirline(request);
  }

  @override
  Future<EmployeeAirlineRoutesResponseModel> getEmployeeAirlineRoutes() {
    return _dataSource.getEmployeeAirlineRoutes();
  }
}
