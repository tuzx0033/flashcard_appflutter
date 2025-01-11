// models/topic_dto.dart

class TopicDTO {
  final int? id;
  final String name;

  TopicDTO({this.id, required this.name});

  // Phương thức từ JSON
  factory TopicDTO.fromJson(Map<String, dynamic> json) {
    return TopicDTO(
      id: json['id'],
      name: json['name'],
    );
  }

  // Phương thức chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
