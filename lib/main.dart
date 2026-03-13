import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SquirrelApp());
}

class SquirrelApp extends StatelessWidget {
  const SquirrelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '松鼠账本',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
