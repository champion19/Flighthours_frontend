import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

/// Excepción personalizada para errores de registro
class RegisterException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  RegisterException({
    required this.message,
    required this.code,
    required this.statusCode,
  });

  @override
  String toString() => message;
}

/// Register data source using Dio
///
/// Note: This endpoint doesn't require authentication (it's used to create new accounts)
class RegisterDatasource {
  final Dio _dio;

  RegisterDatasource({Dio? dio}) : _dio = dio ?? DioClient().client;

  /// Formatea una fecha ISO a formato simple YYYY-MM-DD
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }

  /// Registra un nuevo empleado en el sistema
  ///
  /// Retorna [RegisterResponseModel] si el registro es exitoso (201)
  /// Lanza [RegisterException] si hay error (409 duplicado, u otros errores)
  Future<RegisterResponseModel> registerEmployee(
    EmployeeEntityRegister employee,
  ) async {
    // POST /register solo acepta estos campos:
    // name, email, password, identificationnumber, start_date, end_date, role
    // Los campos bp, airline, active se enviarán después del login via PUT /employees/me
    final Map<String, dynamic> payload = {
      'name': employee.name,
      'email': employee.email,
      'password': employee.password,
      'identificationnumber': employee.idNumber,
      'start_date': _formatDate(employee.fechaInicio),
      'end_date': _formatDate(employee.fechaFin),
      'role': employee.role ?? 'pilot',
    };

    try {
      final response = await _dio.post(
        '/register',
        data: payload, // Dio accepts Map directly
      );

      // Dio already parses JSON to Map
      final registerResponse = RegisterResponseModel.fromMap(response.data);

      if (response.statusCode == 201 && registerResponse.success) {
        // Registro exitoso
        return registerResponse;
      } else {
        // Error del backend (409 duplicado u otro error)
        throw RegisterException(
          message: registerResponse.message,
          code: registerResponse.code,
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server responded with an error
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final registerResponse = RegisterResponseModel.fromMap(data);
          throw RegisterException(
            message: registerResponse.message,
            code: registerResponse.code,
            statusCode: e.response!.statusCode ?? 0,
          );
        }
        throw RegisterException(
          message: 'Server error',
          code: 'SERVER_ERROR',
          statusCode: e.response!.statusCode ?? 0,
        );
      }

      // Connection error

      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage =
            'Tiempo de conexión agotado. Por favor intenta de nuevo.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Error de conexión con el servidor. Verifica que el backend esté corriendo.';
      } else {
        errorMessage = 'Error de red. Verifica tu conexión.';
      }

      throw RegisterException(
        message: errorMessage,
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    } on RegisterException {
      rethrow;
    } catch (e) {
      throw RegisterException(
        message: 'Error inesperado. Por favor intenta de nuevo.',
        code: 'UNEXPECTED_ERROR',
        statusCode: 0,
      );
    }
  }
}
