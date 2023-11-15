import 'package:Elvira/util/tts.dart';
import 'package:screen_brightness_util/screen_brightness_util.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VoiceCommands {
  late String voiceCommand;

  VoiceCommands(this.voiceCommand) {
    recognizeCommand(voiceCommand);
  }

  void recognizeCommand(String command) {
    final List<Map> commands = [
      {
        'name': ['volume', 'audio', 'ouvir'],
        'return': 'Pronto, ajustei o volume',
        'type': 'problem',
        'fix': (String param) {
          VolumeWatcher.setVolume(1.0);
        },
      },
      {
        'name': [
          'brilho',
          'luminosidade',
          'iluminação',
          'claridade',
          'claro',
          'tela'
        ],
        'return': 'Pronto, ajustei o brilho',
        'type': 'problem',
        'fix': (String param) {
          if (param.contains('diminuir') ||
              param.contains('escurecer') ||
              param.contains('abaixe')) {
            ScreenBrightnessUtil().getBrightness().then((value) {
              ScreenBrightnessUtil().setBrightness(value - 0.5);
            });
          } else {
            ScreenBrightnessUtil().setBrightness(1.0);
          }
        },
      },
      {
        'name': ['lanterna', 'luz', 'flash'],
        'return': 'Prontinho!',
        'type': 'feature',
        'fix': (String param) {
          TorchController().toggle();
        },
      },
    ];

    for (var result in commands) {
      for (var name in result['name']) {
        if (command.contains(name)) {
          result['fix'](command);
          tts().say(result['return']);
          return;
        }
      }
    }
  }
}
