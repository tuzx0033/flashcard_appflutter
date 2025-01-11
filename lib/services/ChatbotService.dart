import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIChat {
  final String apiKey =
      ''; // Thay bằng API Key của bạn

  Future<String> getChatResponse(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // Bạn có thể thay đổi model nếu muốn
        'messages': [
          {'role': 'user', 'content': message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response');
    }
  }
}
