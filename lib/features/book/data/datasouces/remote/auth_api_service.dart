import 'package:bookapp/features/book/data/models/login_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../Auth/Tokens.dart';
import '../../../../../core/utils/constants.dart';

class RemoteAuthDataSource {
  final http.Client client;

  RemoteAuthDataSource({required this.client});

  Future<bool> checkUserStatus() async {
    final url = '${Constants.BASE_URL}/api/check-auth-status/';
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Token $token', // Ensure the token is formatted correctly
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['is_authenticated'];
      } else {
        // Handle error

        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle exception

      print('Exception: $e');
      return false;
    }
  }

  Future<LoginData> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.BASE_URL}/api/login/"),
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
        //await storeToken(token);
        return LoginData(token:responseData['token'],user_id: responseData['user_id'].toString(),email: responseData['email'] );
      } else {
        final responseData = jsonDecode(response.body);
        print('Error: ${response.statusCode} - ${response.body}');
        return LoginData(token:null,user_id: null,email: null );

      }
    } catch (e) {
      print('Exception: $e');
      return LoginData(token:null,user_id: null,email: null );

    }
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.BASE_URL}/api/register/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true;

      }
      else {
        final responseData = jsonDecode(response.body);
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<void> forgotPassword(String email) async {

    final response = await http.post(
      Uri.parse("${Constants.BASE_URL}/api/forgot-password/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
    } else {
      final responseData = jsonDecode(response.body);
    }
  }
}
