


import '../../domain/ entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasouces/remote/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource remoteAuthDataSource;

  AuthRepositoryImpl(this.remoteAuthDataSource);

  @override
  Future<Login> login(String email, String password) async {
    final userModel = await remoteAuthDataSource.login(email, password);
    return Login(
      email: userModel.email,
      token: userModel.token,
      user_id: userModel.user_id
    );
  }

  @override
  Future<bool> CheckAuthStatus() async {
    final bool userModel = await remoteAuthDataSource.checkUserStatus();
    return userModel;
  }

  @override
  Future<bool> SignUp(String username ,String email, String password) async {
    final bool userModel = await remoteAuthDataSource.signup(username, email, password);
    return userModel;
  }
}
