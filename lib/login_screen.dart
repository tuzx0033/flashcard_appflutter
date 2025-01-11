import 'package:flutter/material.dart';
import 'package:flashcard_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm package shared_preferences

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ApiService apiService = ApiService();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Gọi API để đăng nhập và nhận response
    Map<String, dynamic> response = await apiService.login(username, password);

    if (response.containsKey('token')) {
      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);

      // Điều hướng đến màn hình Home sau khi lưu token thành công
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Hiển thị thông báo lỗi nếu không có token
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Đăng nhập thất bại")));
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng Nhập"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png',
                height: 150), // Thêm logo cho ứng dụng
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text("Đăng Nhập"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToRegister,
              child: Text(
                "Chưa có tài khoản? Đăng ký tại đây",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            Spacer(),
            Text(
              'Sinh viên HUTECH, ứng dụng học tiếng anh theo phương pháp anki.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
