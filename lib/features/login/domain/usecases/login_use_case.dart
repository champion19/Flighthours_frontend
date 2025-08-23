
import 'package:flight_hours_app/features/login/domain/entities/EmployeeEntity.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);


  Future<EmployeeEntity> call(String email, String password) async {
    return await loginRepository.loginEmployee(email, password);
  }
}
