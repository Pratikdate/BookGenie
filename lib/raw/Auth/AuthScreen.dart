// import 'package:animated_login/animated_login.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../Controller/AuthController.dart';
//
// class AuthScreen extends StatelessWidget {
//   final AuthController authController = Get.put(AuthController());
//
//   Future<String?> onLogin(LoginData data) async {
//
//     await authController.login(data.email, data.password);
//   }
//
//   Future<String?> onSignup(SignUpData data) async {
//     await authController.signup(data.name,data.email, data.password);
//   }
//
//   Future<String?> _onForgotPassword(String email) async {
//     await authController.forgotPassword(email);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedLogin(
//       onLogin: (LoginData data) => onLogin(data),
//       onSignup: (SignUpData data) => onSignup(data),
//       onForgotPassword: (String email) => _onForgotPassword(email),
//       signUpMode: SignUpModes.both,
//       loginDesktopTheme: _desktopTheme,
//       loginMobileTheme: _mobileTheme,
//       loginTexts: _loginTexts,
//       emailValidator: ValidatorModel(
//           validatorCallback: (String? email) => 'What an email! $email'),
//     );
//   }
// }
//
// LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
//   actionButtonStyle: ButtonStyle(
//     foregroundColor: MaterialStateProperty.all(Colors.white70),
//   ),
//   dialogTheme: const AnimatedDialogTheme(
//     languageDialogTheme: LanguageDialogTheme(
//         optionMargin: EdgeInsets.symmetric(horizontal: 80)),
//   ),
//   loadingSocialButtonColor: Colors.blue,
//   loadingButtonColor: Colors.white70,
//   privacyPolicyStyle: const TextStyle(color: Colors.white70),
//   privacyPolicyLinkStyle: const TextStyle(
//       color: Colors.white70, decoration: TextDecoration.underline),
// );
//
// LoginViewTheme get _mobileTheme => LoginViewTheme(
//   backgroundColor: Colors.white70,
//   formFieldBackgroundColor: Colors.white,
//   formWidthRatio: 60,
//   actionButtonStyle: ButtonStyle(
//     foregroundColor: MaterialStateProperty.all(Colors.blue),
//   ),
//   animatedComponentOrder: const <AnimatedComponent>[
//     AnimatedComponent(
//       component: LoginComponents.logo,
//       animationType: AnimationType.right,
//     ),
//     AnimatedComponent(component: LoginComponents.title),
//     AnimatedComponent(component: LoginComponents.description),
//     AnimatedComponent(component: LoginComponents.formTitle),
//     AnimatedComponent(component: LoginComponents.socialLogins),
//     AnimatedComponent(component: LoginComponents.useEmail),
//     AnimatedComponent(component: LoginComponents.form),
//     AnimatedComponent(component: LoginComponents.notHaveAnAccount),
//     AnimatedComponent(component: LoginComponents.forgotPassword),
//     AnimatedComponent(component: LoginComponents.policyCheckbox),
//     AnimatedComponent(component: LoginComponents.changeActionButton),
//     AnimatedComponent(component: LoginComponents.actionButton),
//   ],
//   privacyPolicyStyle: const TextStyle(color: Colors.white70),
//   privacyPolicyLinkStyle: const TextStyle(
//       color: Colors.black, decoration: TextDecoration.underline),
// );
//
// LoginTexts get _loginTexts => LoginTexts(
//   nameHint: _username,
//   login: _login,
//   signUp: _signup,
// );
//
// String get _username => 'Username';
//
// String get _login => 'Login';
//
// String get _signup => 'Sign Up';
