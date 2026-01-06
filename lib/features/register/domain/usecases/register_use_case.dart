import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository registerRepository;

  RegisterUseCase(this.registerRepository);

  /// Ejecuta el caso de uso de registro
  /// Retorna [RegisterResponseModel] con el mensaje del backend
  Future<RegisterResponseModel> call(EmployeeEntityRegister employee) async {
    return await registerRepository.registerEmployee(employee);
  }
}
