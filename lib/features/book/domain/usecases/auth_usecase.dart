


import 'package:bookapp/features/book/domain/%20entities/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<Login> execute(String email, String password) {
    return loginRepository.login(email, password);
  }
}


class SignUpUseCase {
  final AuthRepository authRepository;


  SignUpUseCase(this.authRepository);

  Future<bool> execute(String username,String email, String password) {
    return authRepository.SignUp(username,email, password);
  }
}



class AuthStatusUseCase {
  final AuthRepository authRepository;


  AuthStatusUseCase(this.authRepository);

  Future<bool> execute() {
    return authRepository.CheckAuthStatus();
  }
}