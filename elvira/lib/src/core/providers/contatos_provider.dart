import 'package:flutter/foundation.dart';
import '../models/contato.dart';
import '../db/daos/contato_dao.dart';

class ContatosProvider extends ChangeNotifier {
  final _dao = ContatoDao();

  List<Contato> _contatos = [];
  bool _loading = true;

  List<Contato> get contatos => _contatos;
  List<Contato> get emergencia => _contatos.where((c) => c.ehEmergencia).toList();
  bool get loading => _loading;

  Future<void> init() async {
    _contatos = await _dao.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> adicionar(Contato c) async {
    final id = await _dao.insert(c);
    _contatos.add(c.copyWith(id: id));
    _ordenar();
    notifyListeners();
  }

  Future<void> atualizar(Contato c) async {
    await _dao.update(c);
    final idx = _contatos.indexWhere((x) => x.id == c.id);
    if (idx >= 0) _contatos[idx] = c;
    _ordenar();
    notifyListeners();
  }

  Future<void> remover(int id) async {
    await _dao.delete(id);
    _contatos.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void _ordenar() {
    _contatos.sort((a, b) {
      final ord = a.ordemExibicao.compareTo(b.ordemExibicao);
      return ord != 0 ? ord : a.nome.compareTo(b.nome);
    });
  }
}
