import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  static const String apiUrl = "http://localhost:5178/api"; // Địa chỉ của API

  // Đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      body: json.encode({
        'Username': username,
        'Password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  // Đăng ký
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/register'),
      body: json.encode({
        'Username': username,
        'Email': email,
        'Password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  // Lấy danh sách flashcards
  Future<List<dynamic>> getFlashcards(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/flashcards'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  // Thêm flashcard
  Future<Map<String, dynamic>> addFlashcard(String token, String englishWord,
      String vietnameseTranslation, String exampleSentence) async {
    final response = await http.post(
      Uri.parse('$apiUrl/flashcards'),
      body: json.encode({
        'EnglishWord': englishWord,
        'VietnameseTranslation': vietnameseTranslation,
        'ExampleSentence': exampleSentence,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  // Sửa flashcard
  Future<Map<String, dynamic>> updateFlashcard(
      String token,
      int id,
      String englishWord,
      String vietnameseTranslation,
      String exampleSentence) async {
    final response = await http.put(
      Uri.parse('$apiUrl/flashcards/$id'),
      body: json.encode({
        'EnglishWord': englishWord,
        'VietnameseTranslation': vietnameseTranslation,
        'ExampleSentence': exampleSentence,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  // Xóa flashcard
  Future<Map<String, dynamic>> deleteFlashcard(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/flashcards/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }
}
