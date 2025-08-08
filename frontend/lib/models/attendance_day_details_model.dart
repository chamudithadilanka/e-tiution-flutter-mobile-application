class AttendanceSummary {
  final String classId;
  final String date;
  final int present;
  final int absent;
  final int late;

  AttendanceSummary({
    required this.classId,
    required this.date,
    required this.present,
    required this.absent,
    required this.late,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      classId: json['classId'],
      date: json['date'],
      present: json['summary']['present'],
      absent: json['summary']['absent'],
      late: json['summary']['late'],
    );
  }
}
