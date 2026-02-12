import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterResponseModel>> registerEmployee(
    EmployeeEntityRegister employee,
  );
}
