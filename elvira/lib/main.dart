import 'package:flutter/material.dart';
import 'package:elvira/src/config/routes.dart';

void main() {
  runApp(const ElviraApp());
}

class ElviraApp extends StatelessWidget {
  const ElviraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elvira',
      //initialRoute: AppRoutes.home,
      initialRoute: AppRoutes.dialPad,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
