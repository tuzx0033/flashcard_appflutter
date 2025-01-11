import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String apiKey =
    'AIzaSyCXO_aAfmLQTS-cT9qlwYlTFWxko2wMkdk'; // Thay 'YOUR_GOOGLE_API_KEY' bằng API key thực của bạn

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor:
            Colors.blueAccent, // Sử dụng blueAccent cho tông màu chủ đạo
        hintColor: Colors.blueAccent, // Đặt accent color là blueAccent
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = [];

  // Hàm gọi API Gemini
  Future<void> _sendMessage(String message) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', // Chọn model bạn muốn dùng
      apiKey: apiKey,
    );

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(message); // Thêm tin nhắn của người dùng
      _messages.add(response.text ?? 'No response'); // Thêm phản hồi từ Gemini
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot with Gemini'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Đặt app bar theo blueAccent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: index.isEven
                        ? Colors.blueAccent[50]
                        : Colors.blue[50], // Màu nền các card
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        _messages[index],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      labelStyle: TextStyle(
                          color: Colors.blueAccent), // Màu nhãn nhập liệu
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _controller.clear();
                    }
                  },
                  icon: Icon(Icons.send),
                  color: Colors.blueAccent, // Nút gửi có màu blueAccent
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
