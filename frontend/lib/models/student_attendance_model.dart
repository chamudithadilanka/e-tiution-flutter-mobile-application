class Student {
  final String id;
  final UserID userID;
  final String profileImage;
  final String gender;
  final int age;
  final String stream;
  final String profileImageUrl;

  Student({
    required this.id,
    required this.userID,
    required this.profileImage,
    required this.gender,
    required this.age,
    required this.stream,
    required this.profileImageUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      userID: UserID.fromJson(json['userID']),
      profileImage: json['profileImage'],
      gender: json['gender'],
      age: json['age'],
      stream: json['stream'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

class UserID {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final bool isVerified;

  UserID({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.isVerified,
  });

  factory UserID.fromJson(Map<String, dynamic> json) {
    return UserID(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      role: json['role'],
      isVerified: json['isVerified'],
    );
  }
}
