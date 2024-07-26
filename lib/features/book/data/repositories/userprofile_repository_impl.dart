import 'dart:io';

import 'package:bookapp/features/book/data/datasouces/remote/profile_api_service.dart';
import 'package:bookapp/features/book/domain/repositories/userprofile_repository.dart';

import '../../domain/ entities/profile.dart';

class ProfileRepositoryImpl implements UserprofileRepository {
  final RemoteProfileDataSource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<UserProfile> getUserProfile() async {
    final userData = await profileDataSource.profileDataSource();

    return UserProfile(
      user: userData.user,
      name: userData.name,
      email: userData.email,
      personal_info: userData.personal_info,
      image: userData.image,
    );
  }

  @override
  Future<UserProfile> setUserprofile({required File imageFile, required String email, required String name, required String profileInfo}) async {
    final userData = await profileDataSource.setUserProfileInfoDataSource(imageFile: imageFile, email: email, name: name, profileInfo: profileInfo);

    return UserProfile(
      user: userData.user,
      name: userData.name,
      email: userData.email,
      personal_info: userData.personal_info,
      image: userData.image,
    );
  }
}
