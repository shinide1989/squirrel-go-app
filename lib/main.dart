import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

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
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
