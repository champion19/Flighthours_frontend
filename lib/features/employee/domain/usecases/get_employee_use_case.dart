import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for fetching the current employee's information
class GetEmployeeUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  /// Executes the use case to fetch the current employee
  /// The employee ID is extracted from the JWT token by the backend
  Future<EmployeeResponseModel> call() {
    return _repository.getCurrentEmployee();
  }
}
