import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIChat {
  final String apiKey =
      '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'; // Thay bằng API Key của bạn

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
