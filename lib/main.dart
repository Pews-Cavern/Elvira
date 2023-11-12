import 'package:Elvira/pages/init_page.dart';
import 'package:Elvira/util/battery.dart';
import 'package:Elvira/util/tts.dart';
import 'package:Elvira/util/voice.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Battery().init();
  tts().init();
  Voice().init();


  runApp(
    const MaterialApp(home: InitPage()),
  );
}
