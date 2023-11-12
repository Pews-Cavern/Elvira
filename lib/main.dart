import 'package:Elvira/pages/init_page.dart';
import 'package:Elvira/util/battery.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Battery().init();
  runApp(
    const MaterialApp(home: InitPage()),
  );
}
