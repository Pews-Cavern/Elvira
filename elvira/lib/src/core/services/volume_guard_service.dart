import 'dart:async';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'prefs_service.dart';

/// Mantém o volume do celular acima do mínimo calibrado pelo idoso.
/// Funciona enquanto o app está rodando (primeiro ou segundo plano).
class VolumeGuardService {
  VolumeGuardService._();
  static final instance = VolumeGuardService._();

  StreamSubscription<double>? _sub;
  double _minimo = 0.0;
  bool _pausado = false;

  Future<void> init() async {
    _minimo = await PrefsService.instance.getVolumeCalibracao();
    await FlutterVolumeController.updateShowSystemUI(false);
    final atual = await FlutterVolumeController.getVolume() ?? 0;
    if (atual < _minimo) {
      await FlutterVolumeController.setVolume(_minimo);
    }
    _sub = FlutterVolumeController.addListener(
      (vol) {
        if (_pausado) return;
        if (vol < _minimo) {
          FlutterVolumeController.setVolume(_minimo);
        }
      },
      emitOnStart: false,
    );
  }

  double get minimoAtual => _minimo;

  void pausar() => _pausado = true;

  Future<void> retomarCom(double novoMinimo) async {
    _minimo = novoMinimo;
    _pausado = false;
    final atual = await FlutterVolumeController.getVolume() ?? 0;
    if (atual < _minimo) {
      await FlutterVolumeController.setVolume(_minimo);
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
