import 'dart:convert';
import 'package:flashcard_app/models/topic.dart';
import 'package:http/http.dart' as http;

class FlashcardService {
  static const String _baseUrl =
      'http://localhost:5178/api/flashcards'; // Thay đổi URL API của bạn

  Future<List<Topic>> fetchTopics() async {
    final response = await http.get(Uri.parse('$_baseUrl/topics'));

    if (response.statusCode == 200) {
      // Giải mã JSON và tạo ra danh sách các chủ đề
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Topic.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  // Thêm một Flashcard
  Future<Map<String, dynamic>> addFlashcard(
      String englishWord,
      String vietnameseTranslation,
      String exampleSentence,
      int? topicId) async {
    final url = Uri.parse(_baseUrl);

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'EnglishWord': englishWord,
          'VietnameseTranslation': vietnameseTranslation,
          'ExampleSentence': exampleSentence,
          'TopicId': topicId
        }));

    if (response.statusCode == 201) {
      return json.decode(response.body); // Trả về flashcard mới nếu thành công
    } else {
      throw Exception('Failed to add flashcard');
    }
  }

// Thêm một Topic mới
  Future<Map<String, dynamic>> addTopic(String name) async {
    final url = Uri.parse('$_baseUrl/topics'); // URL API để thêm chủ đề

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name}));

    if (response.statusCode == 201) {
      return json.decode(response.body); // Trả về chủ đề mới nếu thành công
    } else {
      throw Exception('Failed to add topic');
    }
  }
}
