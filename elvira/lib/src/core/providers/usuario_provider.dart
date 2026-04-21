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
    if (_usuario == null) return;
    await salvar(_usuario!.copyWith(tamanhoFonteBase: escala));
  }

  Future<bool> verificarPin(String pin) async {
    return _usuario?.pinCuidador == pin;
  }

  Future<void> definirPin(String pin) async {
    if (_usuario == null) return;
    await salvar(_usuario!.copyWith(pinCuidador: pin));
  }
}
