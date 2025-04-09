import 'package:flutter/material.dart';
import 'src/ui/screens/main_screen.dart';

void main() {
  runApp(const ElviraApp());
}

class ElviraApp extends StatelessWidget {
  const ElviraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elvira Teste',
      home: MainScreen(),
    );
  }
}
