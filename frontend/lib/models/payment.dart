class PaymentSlip {
  final String? id;
  final String studentId;
  final String classId;
  final double amount;
  final String month;
  final String slipFile;

  PaymentSlip({
    this.id,
    required this.studentId,
    required this.classId,
    required this.amount,
    required this.month,
    required this.slipFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'classId': classId,
      'amount': amount,
      'month': month,
      'slipFile': slipFile,
    };
  }

  factory PaymentSlip.fromJson(Map<String, dynamic> json) {
    return PaymentSlip(
      id: json['_id'] as String? ?? json['id'] as String?,
      studentId:
          json['studentId'] as String? ??
          (json['student'] is Map ? json['student']['_id'] as String? : null) ??
          '',
      classId:
          json['classId'] as String? ??
          (json['class'] is Map ? json['class']['_id'] as String? : null) ??
          '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      month: json['month'] as String? ?? '',
      slipFile: json['slipFile'] as String? ?? '',
    );
  }
}
