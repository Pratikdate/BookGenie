

class LoginData {
  final String? token;
  final String? user_id;
  final String? email;

  LoginData({this.token, this.user_id, this.email});


  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      user_id: json['user_id'],
      email: json['email'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': user_id,
      'email': email,

    };
  }
}