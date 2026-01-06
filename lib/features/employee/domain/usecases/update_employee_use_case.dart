import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for updating employee information
class UpdateEmployeeUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  /// Executes the use case to update the current employee's information
  /// The employee ID is extracted from the JWT token by the backend
  Future<EmployeeUpdateResponseModel> call(EmployeeUpdateRequest request) {
    return _repository.updateCurrentEmployee(request);
  }
}
