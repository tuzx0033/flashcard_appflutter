import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt Debug Banner
      title: 'Flashcard App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
