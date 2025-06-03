import 'class_model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final bool isVerified;
  final List<String> joinedClasses;

  //final bool newUser = false;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    required this.isVerified,
    required this.joinedClasses,

    //required this.newUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      joinedClasses: List<String>.from(json['joinedClasses'] ?? []),
      //newUser: json['newUser'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
      'isVerified': isVerified,
      'joinedClasses': joinedClasses,
    };
  }
}
