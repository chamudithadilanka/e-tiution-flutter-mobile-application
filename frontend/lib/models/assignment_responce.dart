class AssignmentResponse {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime createdAt;
  final List<String> materials;
  final List<String> materialUrls;
  final Teacher teacher;

  AssignmentResponse({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.createdAt,
    required this.materials,
    required this.materialUrls,
    required this.teacher,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentResponse(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      materials: List<String>.from(json['materials'] ?? []),
      materialUrls: List<String>.from(json['materialUrls'] ?? []),
      teacher: Teacher.fromJson(json['teacher']),
    );
  }
}

class Teacher {
  final String name;

  Teacher({required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(name: "${json['firstName']} ${json['lastName']}".trim());
  }
}
