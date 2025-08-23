

import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';

class RegisterUseCase {
   final RegisterRepository registerRepository;

  RegisterUseCase(this.registerRepository);


  Future<EmployeeEntityRegister> call(EmployeeEntityRegister employee) async {
    return await registerRepository.registerEmployee(employee);
  }
}
