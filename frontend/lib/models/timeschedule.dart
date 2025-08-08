class Timeschedule {
  final String classId;
  final String teacherId;
  final String day;
  final String subject;
  final String startTime;
  final String endTime;
  final DateTime? endDate; // Make nullable since API doesn't return it
  final String? id;
  final DateTime? createdAt;

  Timeschedule({
    required this.classId,
    required this.teacherId,
    required this.day,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.endDate,
    this.id,
    this.createdAt,
  });

  factory Timeschedule.fromJson(Map<String, dynamic> json) {
    // Handle nested response structure
    final data = json['data'] ?? json;

    return Timeschedule(
      classId: data['classId'] as String,
      teacherId: data['teacherId'] as String,
      day: data['day'] as String,
      subject: data['subject'] as String,
      startTime: data['startTime'] as String,
      endTime: data['endTime'] as String,
      id: data['_id'] as String?,
      createdAt:
          data['createdAt'] != null
              ? DateTime.parse(data['createdAt'] as String)
              : null,
      endDate:
          data['endDate'] != null
              ? DateTime.parse(data['endDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'teacherId': teacherId,
      'day': day,
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (id != null) '_id': id,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
