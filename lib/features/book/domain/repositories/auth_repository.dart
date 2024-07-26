


import '../ entities/auth.dart';

abstract class AuthRepository {
  Future<Login> login(String email, String password);
  Future<bool> SignUp(String username,String email, String password);
  Future<bool> CheckAuthStatus();
}

