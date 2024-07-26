





class UserProfileModel {
  final String? user;
  final String? email;
  final String? personal_info ;
  final String? name;
  final String? image;


  UserProfileModel(
      { this.user, this.email, this.personal_info, this.name, this.image,
      });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      user: json['user'],
      email: json['email'],
      personal_info: json['personal_info'],
      name: json['name'],
      image: json['image'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'email': email,
      'name':name,
      'personal_info':personal_info,
      'image': image,

    };
  }
}
