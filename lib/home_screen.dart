import 'package:flashcard_app/chat_page.dart';

import 'package:flashcard_app/pages/add_flashcard_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/flashcard_api_service.dart';
import '../models/flashcard.dart';
import '../models/topic.dart';
import 'flashcard_flip_screen.dart';
import 'profile_screen.dart';
import 'screens/vocabulary_library_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlashcardApiService apiService = FlashcardApiService();
  List<Topic> topics = [];
  List<Flashcard> flashcards = [];
  List<Topic> filteredTopics = [];
  String? token;
  String username = '';
  String email = '';
  TextEditingController searchController = TextEditingController();

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    setState(() {
      username = prefs.getString('username') ?? 'Chưa có tên người dùng';
      email = prefs.getString('email') ?? 'Chưa có email';
    });

    if (token == null || token!.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _fetchTopics();
    }
  }

  void _fetchTopics() async {
    try {
      List<Topic> fetchedTopics = await apiService.fetchTopics();
      setState(() {
        topics = fetchedTopics;
        filteredTopics = topics; // Đặt tất cả chủ đề vào filteredTopics
      });
    } catch (e) {
      print("Lỗi khi lấy danh sách chủ đề: $e");
    }
  }

  void _fetchFlashcardsByTopic(int topicId) async {
    try {
      List<Flashcard> fetchedFlashcards =
          await apiService.fetchFlashcardsByTopic(topicId);
      setState(() {
        flashcards = fetchedFlashcards;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlashcardFlipScreen(flashcards: flashcards),
        ),
      );
    } catch (e) {
      print("Lỗi khi lấy flashcards: $e");
    }
  }

  void _filterTopics(String query) {
    setState(() {
      filteredTopics = topics
          .where(
              (topic) => topic.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    searchController.addListener(() {
      _filterTopics(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flashcards",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Màu chủ đạo là blueAccent
        actions: [
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VocabularyLibraryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFlashcardPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thêm hàng chứa tiêu đề và nút thêm chủ đề
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chọn chủ đề",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Thêm ô tìm kiếm vào đây
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm chủ đề...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTopics.length,
                itemBuilder: (context, index) {
                  var topic = filteredTopics[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.blueAccent, // Màu chủ đạo cho shadow
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        topic.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("Chủ đề về ${topic.name}"),
                      onTap: () {
                        _fetchFlashcardsByTopic(topic.id);
                      },
                      leading: Icon(
                        Icons.bookmark,
                        color: Colors.blueAccent, // Màu chủ đạo cho icon
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent, // Màu chủ đạo cho icon
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Footer navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set the default active index (e.g., Home)
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
              break;
            case 3:
              // Navigate to Notifications screen
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor:
                Colors.blueAccent, // Màu chủ đạo cho background của items
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
