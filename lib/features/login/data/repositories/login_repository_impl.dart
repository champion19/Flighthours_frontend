import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginDatasource loginDatasource;
  LoginRepositoryImpl(this.loginDatasource);

  @override
  Future<LoginEntity> loginEmployee(String email, String password) async {
    return await loginDatasource.loginEmployee(email, password);
  }

  @override
  Future<void> logoutEmployee() {
    // TODO: implement logoutEmployee
    throw UnimplementedError();
  }
}
