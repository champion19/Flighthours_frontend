import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for updating the employee's airline association
class UpdateEmployeeAirlineUseCase {
  final EmployeeRepository _repository =
      InjectorApp.resolve<EmployeeRepository>();

  Future<Either<Failure, EmployeeAirlineResponseModel>> call(
    EmployeeAirlineUpdateRequest request,
  ) {
    return _repository.updateEmployeeAirline(request);
  }
}
