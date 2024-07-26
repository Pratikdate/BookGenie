import 'dart:io';

import 'package:bookapp/features/book/domain/repositories/userprofile_repository.dart';

import '../ entities/profile.dart';

class UserProfileUseCase {
  final UserprofileRepository userprofileRepository;

  UserProfileUseCase(this.userprofileRepository);

  Future<UserProfile> executeGET() {

    return userprofileRepository.getUserProfile();
  }


  Future<UserProfile> executeSET({required File imageFile, required String email, required String name, required String profileInfo}) {

    return userprofileRepository.setUserprofile(imageFile: imageFile, email: email, name: name, profileInfo: profileInfo);
  }
}


