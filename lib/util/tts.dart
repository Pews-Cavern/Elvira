import 'package:flutter_tts/flutter_tts.dart';

class tts {
  static final tts _tts = tts._internal();
  factory tts() {
    return _tts;
  }
  tts._internal();

  late FlutterTts flutterTts;
  void init() async {
    flutterTts = FlutterTts();
     await flutterTts.setLanguage("pt-BR");
  }

  Future speak(String text) async {
    return await flutterTts.speak(text);
  }
}




