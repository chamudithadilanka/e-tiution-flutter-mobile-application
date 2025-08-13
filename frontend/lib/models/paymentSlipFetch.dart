class PaymentSlipFetch {
  final String id;
  final ClassInfo classInfo;
  final Student student;
  final double amount;
  final String month;
  final String slipFile;
  final String status;
  final DateTime submittedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentSlipFetch({
    required this.id,
    required this.classInfo,
    required this.student,
    required this.amount,
    required this.month,
    required this.slipFile,
    required this.status,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentSlipFetch.fromJson(Map<String, dynamic> json) {
    return PaymentSlipFetch(
      id: json['id'],
      classInfo: ClassInfo.fromJson(json['class']),
      student: Student.fromJson(json['student']),
      amount: json['amount'].toDouble(),
      month: json['month'],
      slipFile: json['slipFile'],
      status: json['status'],
      submittedAt: DateTime.parse(json['submittedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ClassInfo {
  final String id;
  final String description;

  ClassInfo({required this.id, required this.description});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(id: json['_id'], description: json['description']);
  }
}

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}
