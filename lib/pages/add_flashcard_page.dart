import 'package:flashcard_app/models/topic.dart';
import 'package:flutter/material.dart';
import '../services/flashcard_service.dart';
import 'package:flashcard_app/services/flashcard_service.dart';

class AddFlashcardPage extends StatefulWidget {
  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final _englishWordController = TextEditingController();
  final _vietnameseTranslationController = TextEditingController();
  final _exampleSentenceController = TextEditingController();
  int? _selectedTopicId;

  bool _isLoading = false;
  List<Topic> _topics = [];

  void _fetchTopics() async {
    try {
      final flashcardService = FlashcardService();
      List<Topic> fetchedTopics = await flashcardService.fetchTopics();
      setState(() {
        _topics = fetchedTopics;
      });
    } catch (error) {
      print("Error fetching topics: $error");
    }
  }

  void _submitForm() async {
    if (_selectedTopicId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a topic')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final flashcardService = FlashcardService();
      await flashcardService.addFlashcard(
        _englishWordController.text,
        _vietnameseTranslationController.text,
        _exampleSentenceController.text,
        _selectedTopicId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Flashcard added successfully!')));
      _englishWordController.clear();
      _vietnameseTranslationController.clear();
      _exampleSentenceController.clear();
      setState(() {
        _selectedTopicId = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add flashcard')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flashcard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextField(
              controller: _englishWordController,
              labelText: 'Từ vựng tiếng anh',
            ),
            SizedBox(height: 15),
            _buildCustomTextField(
              controller: _vietnameseTranslationController,
              labelText: 'dịch nghĩa',
            ),
            SizedBox(height: 15),
            _buildCustomTextField(
              controller: _exampleSentenceController,
              labelText: 'câu ví dụ',
            ),
            SizedBox(height: 15),
            _buildDropdown(),
            SizedBox(height: 25),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.blueAccent)
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Add Flashcard',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: DropdownButton<int>(
        isExpanded: true,
        hint: Text("chọn chủ đề bạn muốn thêm"),
        value: _selectedTopicId,
        underline: SizedBox(),
        onChanged: (int? newValue) {
          setState(() {
            _selectedTopicId = newValue;
          });
        },
        items: _topics.map<DropdownMenuItem<int>>((Topic topic) {
          return DropdownMenuItem<int>(
            value: topic.id,
            child: Text(topic.name),
          );
        }).toList(),
      ),
    );
  }
}
