import 'topic.dart';

class Flashcard {
  final int id;
  final String englishWord;
  final String vietnameseTranslation;
  final String exampleSentence;
  final int? topicId;
  final Topic? topic;

  Flashcard({
    required this.id,
    required this.englishWord,
    required this.vietnameseTranslation,
    required this.exampleSentence,
    this.topicId,
    this.topic,
  });

  // Phương thức fromJson để chuyển đổi JSON thành đối tượng Flashcard
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      englishWord: json['englishWord'],
      vietnameseTranslation: json['vietnameseTranslation'],
      exampleSentence: json['exampleSentence'],
      topicId: json['topicId'],
      // Kiểm tra xem 'topic' có tồn tại trong JSON hay không, nếu có thì chuyển thành Topic
      topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
    );
  }

  // Phương thức toJson để chuyển đổi đối tượng Flashcard thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'englishWord': englishWord,
      'vietnameseTranslation': vietnameseTranslation,
      'exampleSentence': exampleSentence,
      'topicId': topicId,
      'topic': topic?.toJson(),
    };
  }
}
