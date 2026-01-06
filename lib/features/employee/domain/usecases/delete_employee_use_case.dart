import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for deleting the current employee's account
class DeleteEmployeeUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  /// Executes the use case to delete the current employee
  /// The employee ID is extracted from the JWT token by the backend
  Future<DeleteEmployeeResponseModel> call() {
    return _repository.deleteCurrentEmployee();
  }
}
