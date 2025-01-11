import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vocabulary.dart';

class VocabularyService {
  final String baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en'; // Base URL của API

  Future<Vocabulary?> fetchVocabulary(String word) async {
    // Tạo URL với từ vựng đã nhập
    final url = '$baseUrl/$word';

    try {
      // Thực hiện GET request đến API
      final response = await http.get(Uri.parse(url));

      // Nếu mã trạng thái là 200, parse dữ liệu từ response body
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Vocabulary.fromJson(
            data[0]); // Chuyển đổi dữ liệu thành đối tượng Vocabulary
      } else {
        throw Exception('Không thể tìm thấy từ vựng này');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
