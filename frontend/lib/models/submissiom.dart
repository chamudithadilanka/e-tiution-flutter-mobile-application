class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final String classId;
  final String file;
  final String? comments;
  final DateTime submittedAt;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.classId,
    required this.file,
    this.comments,
    required this.submittedAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['_id'],
      assignmentId: json['assignmentId'],
      studentId: json['studentId'],
      classId: json['classId'],
      file: json['file'],
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
}
