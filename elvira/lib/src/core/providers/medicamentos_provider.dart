import 'package:flutter/foundation.dart';
import '../models/medicamento.dart';
import '../models/dose_medicamento.dart';
import '../db/daos/medicamento_dao.dart';
import '../services/alarm_service.dart';

class MedicamentosProvider extends ChangeNotifier {
  final _medDao = MedicamentoDao();
  final _doseDao = DoseDao();

  List<Medicamento> _medicamentos = [];
  final Map<int, List<DoseMedicamento>> _doses = {};
  bool _loading = true;

  List<Medicamento> get medicamentos => _medicamentos;
  bool get loading => _loading;

  List<DoseMedicamento> dosesDoMedicamento(int id) => _doses[id] ?? [];

  Future<void> init() async {
    _medicamentos = await _medDao.getAtivos();
    for (final m in _medicamentos) {
      _doses[m.id!] = await _doseDao.getByMedicamento(m.id!);
    }
    _loading = false;
    notifyListeners();

    // Agenda alarmes para todos os medicamentos ativos ao iniciar
    _reagendarTodos();
  }

  Future<void> adicionarMedicamento(
    Medicamento m,
    List<DoseMedicamento> doses,
  ) async {
    final id = await _medDao.insert(m);
    final med = m.copyWith(id: id);
    _medicamentos.add(med);
    _doses[id] = [];

    for (final d in doses) {
      final doseId = await _doseDao.insert(d.copyWith(medicamentoId: id));
      final doseComId = d.copyWith(id: doseId, medicamentoId: id);
      _doses[id]!.add(doseComId);
      await AlarmService.agendarDose(doseComId, med);
    }
    notifyListeners();
  }

  Future<void> atualizarMedicamento(
    Medicamento m,
    List<DoseMedicamento> doses,
  ) async {
    await _medDao.update(m);
    final idx = _medicamentos.indexWhere((x) => x.id == m.id);
    if (idx >= 0) _medicamentos[idx] = m;

    // Cancela alarmes das doses antigas antes de substituí-las
    final antigas = _doses[m.id!] ?? [];
    await AlarmService.cancelarDosMedicamento(antigas);

    for (final d in antigas) {
      await _doseDao.delete(d.id!);
    }
    _doses[m.id!] = [];

    for (final d in doses) {
      final doseId = await _doseDao.insert(d.copyWith(medicamentoId: m.id));
      final doseComId = d.copyWith(id: doseId, medicamentoId: m.id);
      _doses[m.id!]!.add(doseComId);
      await AlarmService.agendarDose(doseComId, m);
    }
    notifyListeners();
  }

  Future<void> removerMedicamento(int id) async {
    // Cancela alarmes antes de remover do banco
    final doses = _doses[id] ?? [];
    await AlarmService.cancelarDosMedicamento(doses);

    await _medDao.delete(id);
    _medicamentos.removeWhere((m) => m.id == id);
    _doses.remove(id);
    notifyListeners();
  }

  Medicamento? getMedicamento(int id) {
    try {
      return _medicamentos.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Reagenda todos os alarmes (chamado no init e após boot).
  Future<void> _reagendarTodos() async {
    for (final med in _medicamentos) {
      final doses = _doses[med.id!] ?? [];
      await AlarmService.agendarTodosDoMedicamento(med, doses);
    }
  }
}
