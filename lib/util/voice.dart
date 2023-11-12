import 'package:speech_to_text/speech_to_text.dart' as stt;

class Voice {
  static final Voice _Voice = Voice._internal();
  factory Voice() {
    return _Voice;
  }
  Voice._internal();

  String statusListener(status) {
    return (status);
  }

  stt.SpeechErrorListener errorListener = (error) {
    // print('errorListener $error');
  };
  late stt.SpeechToText speech;
  void init() async {
    speech = stt.SpeechToText();
    await speech.initialize(onStatus: statusListener, onError: errorListener);
  }

  Future startListening() async {
    return await speech.listen(onResult: onSpeechResult);
  }

  Future<String?> onSpeechResult(result) async {
    if (!speech.isListening) {
      return result.recognizedWords;
    }
  }
}
