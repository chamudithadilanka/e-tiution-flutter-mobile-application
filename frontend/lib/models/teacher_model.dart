class TeacherModel {
  final String userID;
  final String? profileImage;
  final String? profileImageBase64;
  final String gender;
  final int age;
  final String qualifications;
  final List<String> subjects;
  final List<String> gradesTaught;
  final String bio;

  TeacherModel({
    required this.userID,
    this.profileImage,
    this.profileImageBase64,
    required this.gender,
    required this.age,
    required this.qualifications,
    required this.subjects,
    required this.gradesTaught,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'profileImage': profileImage,
    'profileImageBase64': profileImageBase64,
    'gender': gender,
    'age': age,
    'qualifications': qualifications,
    'subjects': subjects,
    'gradesTaught': gradesTaught,
    'bio': bio,
  };

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      userID: json['userID'] as String,
      profileImage: json['profileImage'] as String?,
      profileImageBase64: json['profileImageBase64'] as String?,
      gender: json['gender'] as String,
      age: json['age'] as int,
      qualifications: json['qualifications'] as String,
      subjects: List<String>.from(json['subjects'] ?? []),
      gradesTaught: List<String>.from(json['gradesTaught'] ?? []),
      bio: json['bio'] as String,
    );
  }
}
