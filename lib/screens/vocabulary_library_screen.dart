import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/vocabulary_service.dart';
import '../models/vocabulary.dart';

class VocabularyLibraryScreen extends StatefulWidget {
  @override
  _VocabularyLibraryScreenState createState() =>
      _VocabularyLibraryScreenState();
}

class _VocabularyLibraryScreenState extends State<VocabularyLibraryScreen> {
  final TextEditingController _controller = TextEditingController();
  VocabularyService _vocabularyService = VocabularyService();
  Vocabulary? _vocabulary;
  bool _isLoading = false;
  String _errorMessage = '';
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _searchVocabulary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      Vocabulary? vocabulary =
          await _vocabularyService.fetchVocabulary(_controller.text);
      if (vocabulary == null) {
        setState(() {
          _errorMessage = 'Không thể tìm thấy từ vựng này';
        });
      } else {
        setState(() {
          _vocabulary = vocabulary;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể kết nối đến dịch vụ tìm kiếm từ vựng';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thư Viện Từ Vựng', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
        elevation: 12,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input search field with rounded corners
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nhập từ cần tìm',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  hintText: 'Nhập từ vựng bạn cần tra cứu...',
                  hintStyle: TextStyle(color: Colors.blueAccent.shade100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              SizedBox(height: 20),

              // Search button with loading indicator
              ElevatedButton(
                onPressed: _searchVocabulary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Tìm Kiếm',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(height: 20),

              // Error message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),

              // Vocabulary details in card style
              if (_vocabulary != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Từ: ${_vocabulary!.word}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Phát âm:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                          ),
                          ..._vocabulary!.phonetics.map((phonetic) {
                            return Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    if (phonetic.audio.isNotEmpty) {
                                      _playAudio(phonetic.audio);
                                    }
                                  },
                                ),
                                Text(
                                  phonetic.audio,
                                  style: TextStyle(
                                    color: Colors.blueAccent.shade100,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          ..._vocabulary!.meanings.map((meaning) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Loại từ: ${meaning.partOfSpeech}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ...meaning.definitions.map((definition) {
                                  return Text(
                                    '• ${definition.definition}',
                                    style: TextStyle(
                                      color: Colors.blueAccent.shade700,
                                      fontSize: 16,
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
