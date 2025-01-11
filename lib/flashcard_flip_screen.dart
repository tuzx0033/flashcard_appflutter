import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flashcard_app/models/flashcard.dart';

class FlashcardFlipScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  FlashcardFlipScreen({required this.flashcards});

  @override
  _FlashcardFlipScreenState createState() => _FlashcardFlipScreenState();
}

class _FlashcardFlipScreenState extends State<FlashcardFlipScreen> {
  int _currentIndex = 0;

  void _nextCard() {
    if (_currentIndex < widget.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Màu nền nhẹ nhàng
      appBar: AppBar(
        title:
            Text("Flashcards", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal, // Màu sắc của AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: FlipCard(
                direction: FlipDirection.HORIZONTAL,
                front: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.flashcards[_currentIndex].englishWord,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.flashcards[_currentIndex].exampleSentence,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                back: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dịch: ${widget.flashcards[_currentIndex].vietnameseTranslation}",
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Câu ví dụ: ${widget.flashcards[_currentIndex].exampleSentence}",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (widget.flashcards[_currentIndex].topic != null)
                          SizedBox(height: 10),
                        if (widget.flashcards[_currentIndex].topic != null)
                          Text(
                            "Chủ đề: ${widget.flashcards[_currentIndex].topic?.name}",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.teal,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextCard,
              child: Text("Tiếp theo", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Màu nút
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
