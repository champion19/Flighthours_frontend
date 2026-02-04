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

  /// Fetches the routes for the employee's airline
  /// Uses:
  /// 1. GET /employees/airline to get airline_code
  /// 2. GET /airline-routes?airline_code=XX&status=true
  Future<EmployeeAirlineRoutesResponseModel> call() async {
    try {
      // Step 1: Get the employee's airline info
      final airlineResponse = await _employeeRepository.getEmployeeAirline();

      if (!airlineResponse.success || airlineResponse.data == null) {
        return EmployeeAirlineRoutesResponseModel(
          success: false,
          code: airlineResponse.code,
          message: 'No airline associated with employee',
          data: [],
        );
      }

      final airlineCode = airlineResponse.data!.airlineCode;
      if (airlineCode == null || airlineCode.isEmpty) {
        return EmployeeAirlineRoutesResponseModel(
          success: false,
          code: 'NO_AIRLINE_CODE',
          message: 'Employee airline has no code',
          data: [],
        );
      }

      // Step 2: Fetch routes for the airline (only active routes)
      final routes = await _airlineRouteDataSource
          .getAirlineRoutesByAirlineCode(airlineCode, status: true);

      return EmployeeAirlineRoutesResponseModel(
        success: true,
        code: 'SUCCESS',
        message: 'Routes loaded successfully',
        data: routes,
      );
    } catch (e) {
      return EmployeeAirlineRoutesResponseModel(
        success: false,
        code: 'ERROR',
        message: e.toString(),
        data: [],
      );
    }
  }
}
