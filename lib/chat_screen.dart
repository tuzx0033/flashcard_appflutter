import 'package:flashcard_app/services/ChatbotService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final OpenAIChat _chat = OpenAIChat();
  String _response = '';

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      try {
        final response = await _chat.getChatResponse(message);
        setState(() {
          _response = response;
        });
      } catch (error) {
        setState(() {
          _response = 'Error: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            Text('Response:'),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
