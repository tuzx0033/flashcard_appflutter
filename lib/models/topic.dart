class Topic {
  final int id;
  final String name;

  Topic({
    required this.id,
    required this.name,
  });

  // Phương thức fromJson để chuyển đổi JSON thành đối tượng Topic
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
    );
  }

  // Phương thức toJson để chuyển đổi đối tượng Topic thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
