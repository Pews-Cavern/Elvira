import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/contato.dart';
import '../db/daos/contato_dao.dart';

class ContatosProvider extends ChangeNotifier {
  final _dao = ContatoDao();

  List<Contato> _contatos = [];
  bool _loading = true;
  bool _syncing = false;

  List<Contato> get contatos => _contatos;
  List<Contato> get emergencia => _contatos.where((c) => c.ehEmergencia).toList();
  bool get loading => _loading || _syncing;

  Future<void> init() async {
    _contatos = await _dao.getAll();
    _loading = false;
    notifyListeners();
    
    // Inicia sincronização automática em background
    _syncDeviceContacts();
  }

  Future<void> _syncDeviceContacts() async {
    if (_syncing) return;
    
    final hasPermission = await fc.FlutterContacts.requestPermission();
    if (!hasPermission) return;

    _syncing = true;
    notifyListeners();

    try {
      final deviceContacts = await fc.FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      final existingNames = _contatos.map((c) => c.nome.toLowerCase().trim()).toSet();
      
      bool addedAny = false;
      
      for (var dc in deviceContacts) {
        if (dc.phones.isEmpty || dc.displayName.trim().isEmpty) continue;
        
        if (!existingNames.contains(dc.displayName.toLowerCase().trim())) {
          String? fotoPath;
          if (dc.photo != null && dc.photo!.isNotEmpty) {
            final dir = await getApplicationDocumentsDirectory();
            final photoFile = File(p.join(dir.path, 'contato_sync_${DateTime.now().millisecondsSinceEpoch}_${dc.id}.png'));
            await photoFile.writeAsBytes(dc.photo!);
            fotoPath = photoFile.path;
          }

          final novoContato = Contato(
            nome: dc.displayName.trim(),
            telefone: dc.phones.first.number,
            relacao: '', // sem definição padrão
            fotoPath: fotoPath,
          );
          
          await _dao.insert(novoContato);
          addedAny = true;
        }
      }
      
      if (addedAny) {
        _contatos = await _dao.getAll();
        _ordenar();
      }
    } catch (e) {
      debugPrint("Erro ao sincronizar contatos: $e");
    } finally {
      _syncing = false;
      notifyListeners();
    }
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
      if (a.ehFavorito && !b.ehFavorito) return -1;
      if (!a.ehFavorito && b.ehFavorito) return 1;

      final ord = a.ordemExibicao.compareTo(b.ordemExibicao);
      return ord != 0 ? ord : a.nome.compareTo(b.nome);
    });
  }
}
