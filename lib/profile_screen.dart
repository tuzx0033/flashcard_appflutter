import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Loading...';
  String email = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedEmail = prefs.getString('email');

    setState(() {
      username = storedUsername ?? 'tuzx0033';
      email = storedEmail ?? 'tuzx0033@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông Tin Người Dùng"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar_placeholder.png'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(
                        "Username",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(username),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blueAccent),
                      title: Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(email),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to edit profile screen
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label: Text("Chỉnh sửa thông tin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                // Logout action
                _logout();
              },
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
