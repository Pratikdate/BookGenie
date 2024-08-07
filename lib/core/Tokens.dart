import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final tocken=prefs.getString('auth_token');
  return tocken ?? "";
}



Future<void> storeEmail(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<String> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final tocken=prefs.getString('auth_token');
  return tocken ?? "";
}

