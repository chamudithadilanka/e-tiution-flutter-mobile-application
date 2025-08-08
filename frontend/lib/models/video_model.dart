class VideoModel {
  final String id;
  final String title;
  final String videoId;
  final String classId;
  final String teacherId;
  final String? description;
  final String? thumbnailUrl;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.videoId,
    required this.classId,
    required this.teacherId,
    this.description,
    this.thumbnailUrl,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'],
      title: json['title'],
      videoId: json['videoId'],
      classId:
          json['classId'] is Map ? json['classId']['_id'] : json['classId'],
      teacherId:
          json['teacherId'] is Map
              ? json['teacherId']['_id']
              : json['teacherId'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videoId': videoId,
      'classId': classId,
      'teacherId': teacherId,
      if (description != null) 'description': description,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    };
  }
}
