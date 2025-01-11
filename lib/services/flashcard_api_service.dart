import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard.dart';
import '../models/topic.dart';

class FlashcardApiService {
  static const String baseUrl =
      "http://localhost:5178/api/flashcards"; // Thay thế với URL API của bạn

  Future<List<Flashcard>> fetchFlashcards() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Flashcard.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load flashcards');
    }
  }

  Future<List<Topic>> fetchTopics() async {
    final response = await http.get(Uri.parse('$baseUrl/topics'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Topic.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<List<Flashcard>> fetchFlashcardsByTopic(int topicId) async {
    final response = await http.get(Uri.parse('$baseUrl/topic/$topicId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Flashcard.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load flashcards by topic');
    }
  }

  Future<void> addTopic(Topic topic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topics'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': topic.name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add topic');
    }
  }

  Future<bool> addFlashcard(Flashcard flashcard) async {
    final url =
        Uri.parse('http://localhost:5178/api/flashcards'); // Địa chỉ API
    final response = await http.post(
      url,
      body: {
        'topic_id': flashcard.topicId.toString(),
        'english_word': flashcard.englishWord,
        'vietnamese_translation': flashcard.vietnameseTranslation,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
