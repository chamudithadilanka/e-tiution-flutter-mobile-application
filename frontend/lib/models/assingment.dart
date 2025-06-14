// class Assignment {
//   final String? id;
//   final String title;
//   final String? description;
//   final DateTime? dueDate;
//   final String classId;
//   final String teacherId;
//   final List<AssignmentDocument> materials;
//   final DateTime? createdAt;

//   Assignment({
//     this.id,
//     required this.title,
//     this.description,
//     required this.dueDate,
//     required this.classId,
//     required this.teacherId,
//     this.materials = const [],
//     this.createdAt,
//   });

//   factory Assignment.fromJson(Map<String, dynamic> json) {
//     return Assignment(
//       id: json['_id'],
//       title: json['title'],
//       description: json['description'],
//       dueDate: DateTime.parse(json['dueDate']),
//       classId: json['classId'],
//       teacherId: json['teacherId'],
//       materials:
//           (json['materials'] ?? [])
//               .map<AssignmentDocument>(
//                 (item) => AssignmentDocument.fromJson(item),
//               )
//               .toList(),
//       createdAt:
//           json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'dueDate': dueDate?.toIso8601String(),
//       'classId': classId,
//       'teacherId': teacherId,
//       'materials': materials.map((m) => m.toJson()).toList(),
//     };
//   }
// }

// class AssignmentDocument {
//   final String name;
//   final String data; // base64 string in the format "data:<mime>;base64,..."
//   final String? url; // Add this if you need URL
//   final int? size; // Add this if you need size

//   AssignmentDocument({
//     required this.name,
//     required this.data,
//     this.url,
//     this.size,
//   });

//   factory AssignmentDocument.fromJson(Map<String, dynamic> json) {
//     return AssignmentDocument(
//       name: json['name'],
//       data: json['data'],
//       url: json['url'],
//       size: json['size'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'data': data,
//       if (url != null) 'url': url,
//       if (size != null) 'size': size,
//     };
//   }
// }
//===================================================================================

// class Assignment {
//   final String? id;
//   final String title;
//   final String? description;
//   final DateTime? dueDate;
//   final String classId;
//   final String teacherId;
//   final List<AssignmentDocument> materials;
//   final DateTime? createdAt;

//   Assignment({
//     this.id,
//     required this.title,
//     this.description,
//     required this.dueDate,
//     required this.classId,
//     required this.teacherId,
//     this.materials = const [],
//     this.createdAt,
//   });

//   factory Assignment.fromJson(Map<String, dynamic> json) {
//     return Assignment(
//       id: json['_id'] ?? json['id'],
//       title: json['title'] ?? '',
//       description: json['description'],
//       dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
//       classId: json['classId'] ?? '',
//       teacherId: json['teacherId'] ?? '',
//       materials:
//           (json['materials'] as List<dynamic>? ?? []).map<AssignmentDocument>((
//             item,
//           ) {
//             // Handle both string filenames and AssignmentDocument objects
//             if (item is String) {
//               // Server returns filename strings, convert to AssignmentDocument
//               return AssignmentDocument(
//                 name: item,
//                 data: '', // Empty since file is stored on server
//                 url: '', // Will be populated from materialUrls if available
//               );
//             } else if (item is Map<String, dynamic>) {
//               // Full AssignmentDocument object
//               return AssignmentDocument.fromJson(item);
//             } else {
//               // Fallback for unexpected types
//               return AssignmentDocument(name: item.toString(), data: '');
//             }
//           }).toList(),
//       createdAt:
//           json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null && id!.isNotEmpty) 'id': id,
//       'title': title,
//       'description': description,
//       'dueDate': dueDate?.toIso8601String(),
//       'classId': classId,
//       'teacherId': teacherId,
//       'materials': materials.map((m) => m.toJson()).toList(),
//       if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
//     };
//   }

//   @override
//   String toString() {
//     return 'Assignment(id: $id, title: $title, materials: ${materials.length})';
//   }
// }

// class AssignmentDocument {
//   final String name;
//   final String data; // Base64 data URI format: "data:mime/type;base64,..."
//   final String? url; // URL for large files uploaded separately
//   final int? size; // File size in bytes
//   final String? mimeType; // MIME type of the file

//   AssignmentDocument({
//     required this.name,
//     required this.data,
//     this.url,
//     this.size,
//     this.mimeType,
//   });

//   factory AssignmentDocument.fromJson(Map<String, dynamic> json) {
//     return AssignmentDocument(
//       name: json['name'] ?? '',
//       data: json['data'] ?? '',
//       url: json['url'],
//       size: json['size']?.toInt(),
//       mimeType: json['mimeType'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = {'name': name, 'data': data};

//     if (url != null && url!.isNotEmpty) {
//       json['url'] = url;
//     }

//     if (size != null) {
//       json['size'] = size;
//     }

//     if (mimeType != null && mimeType!.isNotEmpty) {
//       json['mimeType'] = mimeType;
//     }

//     return json;
//   }

//   // Helper method to check if this document uses URL or base64 data
//   bool get isUrlBased => url != null && url!.isNotEmpty && data.isEmpty;
//   bool get isDataBased => data.isNotEmpty;

//   @override
//   String toString() {
//     return 'AssignmentDocument(name: $name, size: $size, isUrlBased: $isUrlBased)';
//   }
// }
//===================================================================================

// class Assignment {
//   final String? id;
//   final String title;
//   final String? description;
//   final DateTime? dueDate;
//   final String classId;
//   final String teacherId;
//   final List<AssignmentDocument> materials;
//   final DateTime? createdAt;

//   Assignment({
//     this.id,
//     required this.title,
//     this.description,
//     required this.dueDate,
//     required this.classId,
//     required this.teacherId,
//     this.materials = const [],
//     this.createdAt,
//   });

//   factory Assignment.fromJson(Map<String, dynamic> json) {
//     return Assignment(
//       id: json['_id'] ?? json['id'],
//       title: json['title'] ?? '',
//       description: json['description'],
//       dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
//       // classId: json['classId'] ?? '',
//       // teacherId: json['teacherId'] ?? '',
//       classId:
//           json['classId'] is Map<String, dynamic>
//               ? json['classId']['_id'] ?? ''
//               : json['classId'] ?? '',
//       teacherId:
//           json['teacherId'] is Map<String, dynamic>
//               ? json['teacherId']['_id'] ?? ''
//               : json['teacherId'] ?? '',

//       materials:
//           (json['materials'] as List<dynamic>? ?? []).map<AssignmentDocument>((
//             item,
//           ) {
//             if (item is String) {
//               return AssignmentDocument(name: item, data: '', url: '');
//             } else if (item is Map<String, dynamic>) {
//               return AssignmentDocument.fromJson(item);
//             } else {
//               return AssignmentDocument(name: item.toString(), data: '');
//             }
//           }).toList(),
//       createdAt:
//           json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null && id!.isNotEmpty) 'id': id,
//       'title': title,
//       'description': description,
//       'dueDate': dueDate?.toIso8601String(),
//       'classId': classId,
//       'teacherId': teacherId,
//       'materials': materials.map((m) => m.toJson()).toList(),
//       if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
//     };
//   }

//   @override
//   String toString() {
//     return 'Assignment(id: $id, title: $title, materials: ${materials.length})';
//   }
// }

class AssignmentDocument {
  final String name;
  final String data; // Base64 data URI format
  final String? url; // URL for large files uploaded separately
  final int? size; // File size in bytes
  final String? mimeType; // MIME type of the file

  AssignmentDocument({
    required this.name,
    required this.data,
    this.url,
    this.size,
    this.mimeType,
  });

  factory AssignmentDocument.fromJson(Map<String, dynamic> json) {
    return AssignmentDocument(
      name: json['name'] ?? '',
      data: json['data'] ?? '',
      url: json['url'],
      size: json['size']?.toInt(),
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'name': name, 'data': data};

    if (url != null && url!.isNotEmpty) {
      json['url'] = url;
    }

    if (size != null) {
      json['size'] = size;
    }

    if (mimeType != null && mimeType!.isNotEmpty) {
      json['mimeType'] = mimeType;
    }

    return json;
  }

  bool get isUrlBased => url != null && url!.isNotEmpty && data.isEmpty;
  bool get isDataBased => data.isNotEmpty;

  @override
  String toString() {
    return 'AssignmentDocument(name: $name, size: $size, isUrlBased: $isUrlBased)';
  }
}

class Assignment {
  final String? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String classId;
  final String teacherId;
  final List<AssignmentDocument> materials;
  final List<String> materialUrls;
  final DateTime? createdAt;

  Assignment({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.classId,
    required this.teacherId,
    this.materials = const [],
    this.materialUrls = const [],
    this.createdAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      classId:
          json['classId'] is Map<String, dynamic>
              ? json['classId']['_id'] ?? ''
              : json['classId'] ?? '',
      teacherId:
          json['teacherId'] is Map<String, dynamic>
              ? json['teacherId']['_id'] ?? ''
              : json['teacherId'] ?? '',
      materials:
          (json['materials'] as List<dynamic>? ?? []).map((item) {
            if (item is String) {
              return AssignmentDocument(name: item, data: '', url: '');
            } else if (item is Map<String, dynamic>) {
              return AssignmentDocument.fromJson(item);
            } else {
              return AssignmentDocument(name: item.toString(), data: '');
            }
          }).toList(),
      materialUrls: List<String>.from(json['materialUrls'] ?? []),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'classId': classId,
      'teacherId': teacherId,
      'materials': materials.map((m) => m.toJson()).toList(),
      'materialUrls': materialUrls,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Assignment(id: $id, title: $title, materials: ${materials.length}, materialUrls: $materialUrls)';
  }
}

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
