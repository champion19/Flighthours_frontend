import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for changing the current employee's password
class ChangePasswordUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  /// Executes the use case to change the employee's password
  /// Requires email, current password, new password, and confirmation
  Future<ChangePasswordResponseModel> call(ChangePasswordRequest request) {
    return _repository.changePassword(request);
  }
}
