// ignore_for_file: non_constant_identifier_names

import 'package:Elvira/util/voice_commands.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voice {
  static final Voice _Voice = Voice._internal();
  factory Voice() {
    return _Voice;
  }
  Voice._internal();

  String statusListener(status) {
    return (status);
  }

  SpeechErrorListener errorListener = (error) {
    // print('errorListener $error');
  };
  late SpeechToText speech;
  void init() async {
    speech = SpeechToText();
    await speech.initialize(onStatus: statusListener, onError: errorListener);
  }

  Future<void> startListening() async {
    await speech.listen(onResult: onSpeechResult);
  }

  Future<void> onSpeechResult(retultReturn) async {
    String result = retultReturn.recognizedWords;
    if (!speech.isListening) {
      print(result);
      VoiceCommands(result);
    }
  }
}
