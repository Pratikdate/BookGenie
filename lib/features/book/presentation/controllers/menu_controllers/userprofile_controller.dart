import 'dart:io';

import 'package:bookapp/core/utils/constants.dart';
import 'package:bookapp/features/book/domain/%20entities/profile.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/user_profile_usecase.dart';


class UserprofileController extends GetxController with SingleGetTickerProviderMixin {
  final userProfile = UserProfile(
      user: '',
      name: '',
      email: '',
      personal_info: '',
      image: '${Constants.BASE_URL}/media/profile_images/blankUser.png'
  ).obs;
  final UserProfileUseCase userProfileUseCase;
  var isLoading = true.obs;
  var isImageUpdate=false.obs;

  UserprofileController({required this.userProfileUseCase});

  @override
  void onInit() {
    super.onInit();
    if(userProfile.value.user!.isEmpty ){
      fetchUserProfile();
    }

  }

  void fetchUserProfile() async {
    isLoading(true);
    try {
      final profile = await userProfileUseCase.executeGET();
      userProfile(profile);
    } finally {
      isLoading(false);
    }
  }

  void setUserProfile({required File imageFile, required String email, required String name, required String profileInfo}) async {
    isLoading(true);
    try {

      final profile = await userProfileUseCase.executeSET(imageFile: imageFile, email: email, name: name, profileInfo: profileInfo);
      print(profile);
      userProfile(profile);
    } finally {
      isLoading(false);
    }
  }
}