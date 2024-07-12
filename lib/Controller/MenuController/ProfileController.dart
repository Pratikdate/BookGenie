import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Auth/Tokens.dart';
import '../BookStoreController.dart';

class ProfileController extends GetxController {
  var profileInfo = <String, dynamic>{

    'email': 'example@gmail.com',
    'name': 'example name',
    'personal_info': 'Bio',
    'image': '/media/profile_images/sign.jpg'
  }.obs;
  //bool isSetProfileInfo=false.obs as bool;


  Future<void> UserProfileInfo() async {

    try {
      final response = await http.get(
        Uri.parse('${BookStoreController.BASE_URL}/api/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;

        profileInfo.assignAll(body);
      } else if (response.statusCode == 204) {
        // Handle no content
        profileInfo.clear();
      } else {
        // Handle other status codes
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  Future<void> SetUserProfileInfo(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${BookStoreController.BASE_URL}/api/profile/'),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}',
      });
      request.fields['email'] = profileInfo['email'];
      request.fields['name'] = profileInfo['name'];
      request.fields['personal_info'] = profileInfo['personal_info'];
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        profileInfo.assignAll(json.decode(body) as Map<String, dynamic>);
      } else if (response.statusCode == 204) {
        // Handle no content
        profileInfo.clear();
      } else {
        // Handle other status codes
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

}
