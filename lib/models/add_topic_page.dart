import 'package:flutter/material.dart';
import 'package:flashcard_app/services/api_helper.dart'; // Import ApiService

import 'package:flashcard_app/models/topic_dto.dart'; // Import TopicDTO

class AddTopicPage extends StatelessWidget {
  final TextEditingController _topicController = TextEditingController();
  final ApiService apiService = ApiService(); // Khởi tạo ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Chủ Đề"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                labelText: 'Tên chủ đề',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String topicName = _topicController.text;
                if (topicName.isNotEmpty) {
                  // Tạo đối tượng TopicDTO
                  TopicDTO newTopic = TopicDTO(name: topicName);

                  try {
                    // Gọi API thêm chủ đề
                    await apiService.addTopic(newTopic);

                    // Thông báo thành công và quay lại trang trước
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thêm chủ đề thành công')),
                    );
                    Navigator.pop(context); // Quay lại trang chủ
                  } catch (e) {
                    // Hiển thị lỗi nếu không thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi thêm chủ đề: $e')),
                    );
                  }
                } else {
                  // Thông báo lỗi nếu tên chủ đề trống
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập tên chủ đề')),
                  );
                }
              },
              child: Text('Thêm chủ đề'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
