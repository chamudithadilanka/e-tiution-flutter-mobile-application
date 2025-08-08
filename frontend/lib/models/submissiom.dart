// class Submission {
//   final String id;
//   final String assignmentId;
//   final String studentId;
//   final String classId;
//   final String file;
//   final String? comments;
//   final DateTime submittedAt;

//   Submission({
//     required this.id,
//     required this.assignmentId,
//     required this.studentId,
//     required this.classId,
//     required this.file,
//     this.comments,
//     required this.submittedAt,
//   });

//   factory Submission.fromJson(Map<String, dynamic> json) {
//     return Submission(
//       id: json['_id'],
//       assignmentId: json['assignmentId'],
//       studentId: json['studentId'],
//       classId: json['classId'],
//       file: json['file'],
//       comments: json['comments'],
//       submittedAt: DateTime.parse(json['submittedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'assignmentId': assignmentId,
//       'studentId': studentId,
//       'classId': classId,
//       'file': file,
//       'comments': comments,
//       'submittedAt': submittedAt.toIso8601String(),
//     };
//   }
// }

// class Submission {
//   final String id;
//   final String assignmentId;
//   final String studentId;
//   final String classId;
//   final String file;
//   final String? comments;
//   final DateTime submittedAt;

//   // Optional for display purposes
//   final String? studentName;
//   final String? studentEmail;
//   final String? assignmentTitle;

//   Submission({
//     required this.id,
//     required this.assignmentId,
//     required this.studentId,
//     required this.classId,
//     required this.file,
//     this.comments,
//     required this.submittedAt,
//     this.studentName,
//     this.studentEmail,
//     this.assignmentTitle,
//   });

//   factory Submission.fromJson(Map<String, dynamic> json) {
//     final student = json['studentId'];
//     final assignment = json['assignmentId'];

//     return Submission(
//       id: json['_id'] ?? '',
//       assignmentId:
//           assignment is Map ? assignment['_id'] ?? '' : assignment ?? '',
//       assignmentTitle: assignment is Map ? assignment['title'] : null,
//       studentId: student is Map ? student['_id'] ?? '' : student ?? '',
//       studentName: student is Map ? student['name'] : null,
//       studentEmail: student is Map ? student['email'] : null,
//       classId:
//           json['classId'] is Map
//               ? json['classId']['_id'] ?? ''
//               : json['classId'] ?? '',
//       file: json['file'] ?? '',
//       comments: json['comments'],
//       submittedAt: DateTime.parse(json['submittedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'assignmentId': assignmentId,
//       'studentId': studentId,
//       'classId': classId,
//       'file': file,
//       'comments': comments,
//       'submittedAt': submittedAt.toIso8601String(),
//     };
//   }

//   @override
//   String toString() {
//     return 'Submission(student: $studentName, file: $file, submittedAt: $submittedAt)';
//   }
// }

class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final String classId;
  final String file;
  final String? comments;
  final DateTime submittedAt;

  // Optional for display purposes
  final String? studentName;
  final String? studentEmail;
  final String? assignmentTitle;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.classId,
    required this.file,
    this.comments,
    required this.submittedAt,
    this.studentName,
    this.studentEmail,
    this.assignmentTitle,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    final student = json['studentId'];
    final assignment = json['assignmentId'];

    return Submission(
      id: json['_id'] ?? '',
      assignmentId:
          assignment is Map ? assignment['_id'] ?? '' : assignment ?? '',
      assignmentTitle: assignment is Map ? assignment['title'] : null,
      studentId: student is Map ? student['_id'] ?? '' : student ?? '',
      studentName: student is Map ? student['name'] : null,
      studentEmail: student is Map ? student['email'] : null,
      classId:
          json['classId'] is Map
              ? json['classId']['_id'] ?? ''
              : json['classId'] ?? '',
      file: json['file'] ?? '',
      comments: json['comments'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'classId': classId,
      'file': file,
      'comments': comments,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Submission(student: $studentName, file: $file, submittedAt: $submittedAt)';
  }
}
