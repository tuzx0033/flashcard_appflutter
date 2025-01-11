import 'package:flashcard_app/models/topic_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class TopicService {
  final String baseUrl =
      'http://localhost:5178/api'; // Đặt URL API của bạn vào đây

  // Phương thức lấy danh sách chủ đề từ API
  Future<List<dynamic>> getTopics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/flashcards/topics'));

      if (response.statusCode == 200) {
        // Nếu API trả về thành công, parse JSON và trả về danh sách chủ đề
        return json.decode(response.body);
      } else {
        // Nếu có lỗi từ API
        throw Exception('Lỗi khi lấy danh sách chủ đề');
      }
    } catch (e) {
      // In lỗi ra console và trả về danh sách trống
      debugPrint("Lỗi khi lấy danh sách chủ đề: $e");
      return [];
    }
  }

  Future<void> addTopic(TopicDTO topic) async {
    final url = Uri.parse('$baseUrl/api/topics');
    final headers = {
      'Content-Type': 'application/json',
      // Nếu cần gửi token thì thêm vào đây
      // 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(topic.toJson()),
      );

      if (response.statusCode == 201) {
        // Nếu thêm topic thành công
        print("Topic đã được thêm thành công!");
        // Cập nhật lại UI hoặc làm gì đó sau khi thêm thành công
      } else {
        // Nếu có lỗi
        throw Exception('Failed to add topic');
      }
    } catch (e) {
      print("Lỗi khi thêm topic: $e");
    }
  }

  // Phương thức lấy flashcards theo chủ đề
  Future<List<dynamic>> getFlashcardsByTopic(String topicId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/flashcards/$topicId'));

      if (response.statusCode == 200) {
        // Nếu API trả về thành công, parse JSON và trả về danh sách flashcards
        return json.decode(response.body);
      } else {
        // Nếu có lỗi từ API
        throw Exception('Lỗi khi lấy flashcards cho chủ đề');
      }
    } catch (e) {
      // In lỗi ra console và trả về danh sách trống
      debugPrint("Lỗi khi lấy flashcards: $e");
      return [];
    }
  }
}
