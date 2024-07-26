


import 'dart:io';

import 'package:bookapp/features/book/data/models/user_profile_model.dart';

import '../ entities/book.dart';
import '../ entities/profile.dart';


abstract class UserprofileRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> setUserprofile({required File imageFile,required String email,required String name,required String profileInfo});

}

