import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Login successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "user-not-found") {
        message = "Email not found, please signup first";
      } else if (e.code == "wrong-password") {
        message = "Wrong password or email address";
      } else {
        message = e.code;
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Registration successful, please login", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offNamed('/auth');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "weak-password") {
        message = "Password provided is too weak";
      } else if (e.code == "email-already-in-use") {
        message = "Email already in use";
      } else {
        message = e.code;
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "user-not-found") {
        message = "User not found";
      } else {
        message = e.code;
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }
}
