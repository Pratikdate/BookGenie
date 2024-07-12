import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Auth/Tokens.dart';
import 'BookStoreController.dart';






class AuthController extends GetxController {

  var isAuthenticated = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserStatus();
  }


  Future<void> checkUserStatus() async {
    final url = '${BookStoreController.BASE_URL}/api/check-auth-status/';
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Ensure the token is formatted correctly
        },
      );

      print(response.body);
      print(token);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        isAuthenticated.value = responseData['is_authenticated'] as bool;
      } else {
        // Handle error
        isAuthenticated.value = false;
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exception
      isAuthenticated.value = false;
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> login(String email, String password) async {

    final response = await http.post(
      Uri.parse("${BookStoreController.BASE_URL}/api/login/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String token = responseData['token'];
      print(token);
      await storeToken(token);
      Get.snackbar("Success", "Login successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offAllNamed('/home');
    } else {
      final responseData = jsonDecode(response.body);
      Get.snackbar("Error", responseData['message'] ?? "Login failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> signup(String username,String email, String password) async {
    final response = await http.post(
      Uri.parse("${BookStoreController.BASE_URL}/api/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username':email,
        'password': password,
      }),
    );



    if (response.statusCode == 201) {
      Get.snackbar("Success", "Registration successful, please login", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offNamed('/auth');
    } else {
      final responseData = jsonDecode(response.body);
      Get.snackbar("Error", responseData['message'] ?? "Registration failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("${BookStoreController.BASE_URL}/api/forgot-password/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Password reset email sent", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    } else {
      final responseData = jsonDecode(response.body);
      Get.snackbar("Error", responseData['message'] ?? "Failed to send password reset email", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }
}
