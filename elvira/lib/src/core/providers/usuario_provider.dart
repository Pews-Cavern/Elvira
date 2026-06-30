import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../db/daos/usuario_dao.dart';

class UsuarioProvider extends ChangeNotifier {
  final _dao = UsuarioDao();

  Usuario? _usuario;
  bool _loading = true;

  Usuario? get usuario => _usuario;
  bool get loading => _loading;
  bool get onboardingCompleto => _usuario?.onboardingCompleto ?? false;
  double get escalaFonte => _usuario?.tamanhoFonteBase ?? 1.0;

  Future<void> init() async {
    _usuario = await _dao.get();
    _loading = false;
    notifyListeners();
  }

  Future<void> salvar(Usuario u) async {
    final id = await _dao.upsert(u);
    _usuario = u.copyWith(id: id);
    notifyListeners();
  }

  Future<void> concluirOnboarding() async {
    if (_usuario == null) return;
    await salvar(_usuario!.copyWith(onboardingCompleto: true));
  }

  Future<void> atualizarEscalaFonte(double escala) async {
    final u = _usuario ?? const Usuario(nome: '');
    await salvar(u.copyWith(tamanhoFonteBase: escala));
  }

  bool get temCuidador => _usuario?.temCuidador ?? false;

  Future<bool> verificarPin(String pin) async {
    final pinAtual = _usuario?.pinCuidador;
    if (pinAtual == null || pinAtual.isEmpty) return false;
    return pinAtual == pin;
  }

  Future<void> definirPin(String pin) async {
    if (_usuario == null) return;
    await salvar(_usuario!.copyWith(pinCuidador: pin));
  }

  Future<void> definirCuidador(bool temCuidador, {String? pin}) async {
    if (_usuario == null) return;
    if (temCuidador) {
      await salvar(_usuario!.copyWith(temCuidador: true, pinCuidador: pin));
    } else {
      await salvar(_usuario!.copyWith(temCuidador: false, clearPinCuidador: true));
    }
  }

  String get modoDaltonico => _usuario?.modoDaltonico ?? 'normal';

  Future<void> definirModoDaltonico(String modo) async {
    final u = _usuario ?? const Usuario(nome: '');
    await salvar(u.copyWith(modoDaltonico: modo));
  }

  Future<void> alternarAppVisivel(String appId, bool visivel) async {
    if (_usuario == null) return;
    final list = List<String>.from(_usuario!.appsOcultos);
    if (visivel) {
      list.remove(appId);
    } else {
      if (!list.contains(appId)) list.add(appId);
    }
    await salvar(_usuario!.copyWith(appsOcultos: list));
  }
}
