// class ClassModel {
//   final String id;
//   final String className;
//   final String subject;
//   final String grade;
//   final Map<String, dynamic> teacher; // updated
//   final List<dynamic> students; // updated

//   ClassModel({
//     required this.id,
//     required this.className,
//     required this.subject,
//     required this.grade,
//     required this.teacher,
//     required this.students,
//   });

//   factory ClassModel.fromJson(Map<String, dynamic> json) {
//     return ClassModel(
//       id: json['_id'] ?? '',
//       className: json['className'] ?? '',
//       subject: json['subject'] ?? '',
//       grade: json['grade'] ?? '',
//       teacher: json['teacher'] ?? {}, // full teacher object
//       students: json['students'] ?? [], // full list of student objects
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'className': className,
//       'subject': subject,
//       'grade': grade,
//       'teacher': teacher,
//       'students': students,
//     };
//   }
// }

// class ClassModel {
//   final String id;
//   final String className;
//   final String subject;
//   final String grade;
//   final String description;
//   final String? profileImageUrl; // Optional
//   final Map<String, dynamic> teacher;
//   final List<dynamic> students;
//   final String? profileImageBase64; // Optional base64 string for upload

//   ClassModel({
//     required this.id,
//     required this.className,
//     required this.subject,
//     required this.grade,
//     required this.description,
//     this.profileImageUrl,
//     required this.teacher,
//     required this.students,
//     this.profileImageBase64, // make optional in constructor too
//   });

//   factory ClassModel.fromJson(Map<String, dynamic> json) {
//     return ClassModel(
//       id: json['_id'] ?? '',
//       className: json['className'] ?? '',
//       subject: json['subject'] ?? '',
//       grade: json['grade'] ?? '',
//       description: json['description'] ?? '',
//       profileImageUrl: json['profileImageUrl'], // optional
//       teacher: json['teacher'] ?? {},
//       students: json['students'] ?? [],
//       profileImageBase64: json['profileImageBase64'], // optional on fetch
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'className': className,
//       'subject': subject,
//       'grade': grade,
//       'description': description,
//       'profileImageUrl': profileImageUrl,
//       'teacher': teacher,
//       'students': students,
//       'profileImageBase64': profileImageBase64, // optional on upload
//     };
//   }
// }

class ClassModel {
  final String id;
  final String className;
  final String subject;
  final String grade;
  final String description;
  final Teacher teacher;
  final List<Students> students;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassModel({
    required this.id,
    required this.className,
    required this.subject,
    required this.grade,
    required this.description,
    required this.teacher,
    required this.students,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'],
      className: json['className'],
      subject: json['subject'],
      grade: json['grade'],
      description: json['description'],
      teacher: Teacher.fromJson(json['teacher']),
      students: List<Students>.from(
        json['students'].map((x) => Students.fromJson(x)),
      ),
      profileImageUrl: json['profileImageUrl'],
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
  final String? id;
  final String? name;
  final String? email;

  Students({required this.id, required this.name, required this.email});

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(id: json['_id'], name: json['name'], email: json['email']);
  }
}
