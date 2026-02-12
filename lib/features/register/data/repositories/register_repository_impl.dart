import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/register/data/datasources/register_datasource.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterDatasource registerDatasource;

  RegisterRepositoryImpl(this.registerDatasource);

  @override
  Future<Either<Failure, RegisterResponseModel>> registerEmployee(
    EmployeeEntityRegister employee,
  ) async {
    try {
      final result = await registerDatasource.registerEmployee(employee);
      return Right(result);
    } on RegisterException catch (e) {
      return Left(
        Failure(message: e.message, code: e.code, statusCode: e.statusCode),
      );
    } catch (e) {
      return Left(
        Failure(message: 'Unexpected error occurred', code: 'UNEXPECTED_ERROR'),
      );
    }
  }
}
