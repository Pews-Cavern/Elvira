import 'package:flutter/foundation.dart';

import '../db/daos/consulta_dao.dart';
import '../models/consulta_medica.dart';
import '../services/consulta_service.dart';

class ConsultasProvider extends ChangeNotifier {
  final _dao = ConsultaDao();

  List<ConsultaMedica> _consultas = [];
  bool _loading = true;

  List<ConsultaMedica> get consultas => _consultas;
  bool get loading => _loading;

  Future<void> init() async {
    _consultas = await _dao.getAll();
    _loading = false;
    notifyListeners();
    _reagendarTodas();
  }

  Future<void> adicionarConsulta(ConsultaMedica consulta) async {
    final id = await _dao.insert(consulta);
    final consultaComId = consulta.copyWith(id: id);
    _consultas.add(consultaComId);
    _consultas.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    await ConsultaService.agendarConsulta(consultaComId);
    notifyListeners();
  }

  Future<void> atualizarConsulta(ConsultaMedica consulta) async {
    await _dao.update(consulta);
    final idx = _consultas.indexWhere((x) => x.id == consulta.id);
    if (idx >= 0) {
      _consultas[idx] = consulta;
      _consultas.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
    if (consulta.id != null) {
      await ConsultaService.cancelarConsulta(consulta.id!);
      await ConsultaService.agendarConsulta(consulta);
    }
    notifyListeners();
  }

  Future<void> removerConsulta(int id) async {
    await ConsultaService.cancelarConsulta(id);
    await _dao.delete(id);
    _consultas.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  ConsultaMedica? getConsulta(int id) {
    try {
      return _consultas.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _reagendarTodas() async {
    for (final consulta in _consultas) {
      await ConsultaService.agendarConsulta(consulta);
    }
  }
}