import 'dart:async';
import 'dart:convert';
import 'package:bookapp/features/book/domain/%20entities/auth.dart';
import 'package:bookapp/features/book/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/Tokens.dart';

import 'package:connectivity_plus/connectivity_plus.dart';





class AuthController extends GetxController {

  var isAuthenticated = false.obs;
  var isLoading = true.obs;
  final LoginUseCase loginUseCase;
  late final SignUpUseCase signUpUseCase;
  late final AuthStatusUseCase authStatusUseCase;
  var network_state=true.obs;
  late final token=''.obs;

  AuthController({required this.loginUseCase,required this.signUpUseCase,required this.authStatusUseCase});

  @override
  Future<void> onInit() async {
    super.onInit();
    checkNetworkStatus();
    token.value= await getToken();
    Timer(
        const Duration(seconds: 3),()=>ChackAuthStatus());
  }



  Future<void> checkNetworkStatus() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.mobile) {
      // Mobile network is available
      print('Mobile network is available');
      network_state(true);
    } else if (result == ConnectivityResult.wifi) {
      // Wi-Fi is available
      print('Wi-Fi is available');
      network_state(true);
    } else {
      // No network is available
      print('No network is available');
      network_state(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final Login login_data = await loginUseCase.execute(email, password);
      await storeToken(login_data.token!);
      Get.snackbar("Success", "Login successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offAllNamed('/home');

    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String username,String email, String password) async {
    try {
      final bool login_data = await signUpUseCase.execute(username,email, password);
      Get.snackbar("Success",login_data ?"Registration successful, please login":"Registration failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: login_data?Colors.green:Colors.red);


    } catch (error) {

      Get.snackbar("Error",  "Registration failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
//
      throw error;
    }
  }

  Future<void> ChackAuthStatus() async {
    try {
      final bool login_data = await authStatusUseCase.execute();
      if(login_data){
        isAuthenticated.value=true;
        isLoading.value=false;

      }
      else{
        isLoading.value=false;
      }

    } catch (error) {
      isLoading.value=false;

      throw error;
    }
  }

}
