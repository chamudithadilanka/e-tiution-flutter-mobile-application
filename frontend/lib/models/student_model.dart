import 'user_model.dart';

class StudentModel {
  // final String userID; // Must be 'userID' (capital D) to match backend
  // final String profileImage;
  // final String gender;
  // final int age;
  // final String stream;

  // StudentModel({
  //   required this.userID,
  //   required this.profileImage,
  //   required this.gender,
  //   required this.age,
  //   required this.stream,
  // });

  // // Convert to JSON with correct field names
  // Map<String, dynamic> toJson() {
  //   return {
  //     'userID': userID, // Must match backend exactly
  //     'profileImage': profileImage,
  //     'gender': gender,
  //     'age': age,
  //     'stream': stream,
  //   };
  // }

  // factory StudentModel.fromJson(Map<String, dynamic> json) {
  //   return StudentModel(
  //     userID: json['_id'] ?? json['userId'] ?? '',
  //     profileImage: json['profileImage'] ?? '',
  //     gender: json['gender'] ?? '',
  //     age: json['age']?.toInt() ?? 0,
  //     stream: json['stream'] ?? '',
  //     // Add other fields
  //   );
  // }

  // class StudentModel {
  //   final String userID;
  //   final String profileImage;
  //   final String gender;
  //   final int age;
  //   final String stream;

  //   StudentModel({
  //     required this.userID,
  //     required this.profileImage,
  //     required this.gender,
  //     required this.age,
  //     required this.stream,
  //   });

  //   factory StudentModel.fromBackendResponse(Map<String, dynamic> json) {
  //     // Handle the populated userID object from backend
  //     final userData =
  //         json['userID'] is Map ? json['userID'] as Map<String, dynamic> : {};

  //     return StudentModel(
  //       userID: userData['_id'] ?? json['userID'] ?? '',
  //       profileImage: json['profileImage'] ?? '',
  //       gender: json['gender'] ?? '',
  //       age: json['age']?.toInt() ?? 0,
  //       stream: json['stream'] ?? '',
  //     );
  //   }
  // }

  final String userID;
  final String? profileImage; // Stores the filename returned from backend
  final String? profileImageBase64; // Used for uploading (temporary)
  final String gender;
  final int age;
  final String stream;

  StudentModel({
    required this.userID,
    this.profileImage,
    this.profileImageBase64,
    required this.gender,
    required this.age,
    required this.stream,
  });

  // Convert to JSON with null safety
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'userID': userID,
      'gender': gender,
      'age': age,
      'stream': stream,
    };

    // Only include if not null
    if (profileImage != null) {
      json['profileImage'] = profileImage;
    }
    if (profileImageBase64 != null) {
      json['profileImageBase64'] = profileImageBase64;
    }

    return json;
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      userID: json['userID'] ?? json['_id'] ?? json['userId'] ?? '',
      profileImage: json['profileImage'] as String?,
      gender: json['gender'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      stream: json['stream'] as String? ?? '',
    );
  }
}
