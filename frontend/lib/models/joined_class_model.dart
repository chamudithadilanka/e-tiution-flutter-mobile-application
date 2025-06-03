// class JoinedClassesResponse {
//   final bool success;
//   final List<Class>? joinedClasses;
//   final String? error;

//   JoinedClassesResponse({
//     required this.success,
//     this.joinedClasses,
//     this.error,
//   });

//   factory JoinedClassesResponse.fromJson(Map<String, dynamic> json) {
//     return JoinedClassesResponse(
//       success: json['success'],
//       joinedClasses:
//           json['joinedClasses'] != null
//               ? (json['joinedClasses'] as List)
//                   .map((i) => Class.fromJson(i))
//                   .toList()
//               : null,
//       error: json['error'],
//     );
//   }
// }

// class Class {
//   final String id;
//   final String name;
//   final String description;
//   final Teacher teacher;
//   // Add other class properties as needed

//   Class({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.teacher,
//   });

//   factory Class.fromJson(Map<String, dynamic> json) {
//     return Class(
//       id: json['_id'],
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       teacher: Teacher.fromJson(json['teacher']),
//     );
//   }
// }

// class Teacher {
//   final String id;
//   final String name;
//   final String email;
//   final String? profileImageUrl;
//   final String role;

//   Teacher({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     this.profileImageUrl,
//   });

//   factory Teacher.fromJson(Map<String, dynamic> json) {
//     return Teacher(
//       id: json['_id'],
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       profileImageUrl: json['profileImageUrl'],
//       role: json['role'] ?? 'teacher',
//     );
//   }
// }

class ClassModels {
  final String id;
  final String className;
  final String subject;
  final String grade;
  final String description;
  final Teacher teacher;
  final List<Students> students;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassModels({
    required this.id,
    required this.className,
    required this.subject,
    required this.grade,
    required this.description,
    required this.teacher,
    required this.students,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModels.fromJson(Map<String, dynamic> json) {
    return ClassModels(
      id: json['_id'],
      className: json['className'],
      subject: json['subject'],
      grade: json['grade'],
      description: json['description'],
      teacher: Teacher.fromJson(json['teacher']),
      students: List<Students>.from(
        (json['students'] ?? []).map((x) => Students.fromJson(x)),
      ),
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Teacher {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

class Students {
  final String id;

  Students({required this.id});

  factory Students.fromJson(dynamic json) {
    if (json is String) {
      return Students(id: json);
    } else {
      return Students(id: json['_id'] ?? '');
    }
  }
}
