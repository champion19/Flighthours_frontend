import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for deleting the current employee's account
class DeleteEmployeeUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  Future<Either<Failure, DeleteEmployeeResponseModel>> call() {
    return _repository.deleteCurrentEmployee();
  }
}
