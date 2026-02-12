import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/domain/repositories/employee_repository.dart';

/// Use case for fetching the employee's airline routes
///
/// This use case:
/// 1. First fetches the employee's airline info to get the airline_code
/// 2. Then fetches routes from /airline-routes?airline_code=XX&status=true
class GetEmployeeAirlineRoutesUseCase {
  final EmployeeRepository _employeeRepository =
      InjectorApp.resolve<EmployeeRepository>();
  final AirlineRouteRemoteDataSource _airlineRouteDataSource =
      InjectorApp.resolve<AirlineRouteRemoteDataSource>();

  Future<Either<Failure, EmployeeAirlineRoutesResponseModel>> call() async {
    // Step 1: Get the employee's airline info
    final airlineResult = await _employeeRepository.getEmployeeAirline();

    return await airlineResult.fold((failure) async => Left(failure), (
      airlineResponse,
    ) async {
      if (!airlineResponse.success || airlineResponse.data == null) {
        return Left(
          Failure(
            message: 'No airline associated with employee',
            code: airlineResponse.code,
          ),
        );
      }

      final airlineCode = airlineResponse.data!.airlineCode;
      if (airlineCode == null || airlineCode.isEmpty) {
        return Left(
          Failure(
            message: 'Employee airline has no code',
            code: 'NO_AIRLINE_CODE',
          ),
        );
      }

      try {
        // Step 2: Fetch routes for the airline (only active routes)
        final routes = await _airlineRouteDataSource
            .getAirlineRoutesByAirlineCode(airlineCode, status: true);

        return Right(
          EmployeeAirlineRoutesResponseModel(
            success: true,
            code: 'SUCCESS',
            message: 'Routes loaded successfully',
            data: routes,
          ),
        );
      } catch (e) {
        return Left(Failure(message: e.toString(), code: 'ERROR'));
      }
    });
  }
}
