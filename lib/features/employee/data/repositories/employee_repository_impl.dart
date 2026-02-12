import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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

  Failure _handleError(dynamic e) {
    if (e is DioException && e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        return Failure(
          message: data['message']?.toString() ?? 'Server error',
          code: data['code']?.toString(),
          statusCode: e.response!.statusCode,
        );
      }
      return Failure(
        message: 'Server error',
        statusCode: e.response!.statusCode,
      );
    }
    return Failure(message: 'Unexpected error occurred');
  }

  @override
  Future<Either<Failure, EmployeeResponseModel>> getCurrentEmployee() async {
    try {
      return Right(await _dataSource.getCurrentEmployee());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeUpdateResponseModel>> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  ) async {
    try {
      return Right(await _dataSource.updateCurrentEmployee(request));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ChangePasswordResponseModel>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      return Right(await _dataSource.changePassword(request));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, DeleteEmployeeResponseModel>>
  deleteCurrentEmployee() async {
    try {
      return Right(await _dataSource.deleteCurrentEmployee());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeAirlineResponseModel>>
  getEmployeeAirline() async {
    try {
      return Right(await _dataSource.getEmployeeAirline());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeAirlineResponseModel>> updateEmployeeAirline(
    EmployeeAirlineUpdateRequest request,
  ) async {
    try {
      return Right(await _dataSource.updateEmployeeAirline(request));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeAirlineRoutesResponseModel>>
  getEmployeeAirlineRoutes() async {
    try {
      return Right(await _dataSource.getEmployeeAirlineRoutes());
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
