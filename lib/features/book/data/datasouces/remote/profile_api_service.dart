
import 'dart:convert';
import 'dart:io';
import 'package:bookapp/features/book/data/models/user_profile_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/Tokens.dart';
import '../../../../../core/utils/constants.dart';

class RemoteProfileDataSource {

  final http.Client client;

  RemoteProfileDataSource({required this.client});



  Future <UserProfileModel> profileDataSource()async{

    try{
      final response = await
      http.get(Uri.parse('${Constants.BASE_URL}/api/profile/'),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Do something with the response data

        return UserProfileModel(
          user: body['user'].toString(),
          name: body['name'],
          email: body['email'],
          personal_info: body['personal_info'],
            image: "${Constants.BASE_URL}/${body['image']}"
        );


      } else if(response.statusCode == 204){
        print("data not found");
        // Handle error

      }
    }catch(e){
      print(e);

    }
    return UserProfileModel();
  }



  Future<UserProfileModel> setUserProfileInfoDataSource({required File imageFile,required String email,required String name,required String profileInfo}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.BASE_URL}/api/profile/'),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}',
      });
      request.fields['email'] = email;
      request.fields['name'] =name;
      request.fields['personal_info'] = profileInfo;
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      }

      var response = await request.send();
      if (response.statusCode == 200) {
        final dynamic body = await response.stream.bytesToString();
        return UserProfileModel(
            user: body['user'].toString(),
            name: body['name'],
            email: body['email'],
            personal_info: body['personal_info'],
            image: "${Constants.BASE_URL}/${body['image']}"
        );
      }
      else {
        // Handle other status codes
        print('Error: ${response.statusCode}');
        return UserProfileModel();
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      return UserProfileModel();
    }
  }

}