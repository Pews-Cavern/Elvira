import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/medicamento.dart';
import '../../models/dose_medicamento.dart';

class MedicamentoDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<Medicamento>> getAtivos() async {
    final db = await _db;
    final rows = await db.query('medicamento', where: 'ativo = 1', orderBy: 'nome ASC');
    return rows.map(Medicamento.fromMap).toList();
  }

  Future<List<Medicamento>> getAll() async {
    final db = await _db;
    final rows = await db.query('medicamento', orderBy: 'nome ASC');
    return rows.map(Medicamento.fromMap).toList();
  }

  Future<int> insert(Medicamento m) async {
    final db = await _db;
    return db.insert('medicamento', m.toMap()..remove('id'));
  }

  Future<void> update(Medicamento m) async {
    final db = await _db;
    await db.update('medicamento', m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.update('medicamento', {'ativo': 0}, where: 'id = ?', whereArgs: [id]);
  }
}

class DoseDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<DoseMedicamento>> getByMedicamento(int medicamentoId) async {
    final db = await _db;
    final rows = await db.query(
      'dose_medicamento',
      where: 'medicamento_id = ? AND ativo = 1',
      whereArgs: [medicamentoId],
      orderBy: 'horario ASC',
    );
    return rows.map(DoseMedicamento.fromMap).toList();
  }

  Future<List<DoseMedicamento>> getAll() async {
    final db = await _db;
    final rows = await db.query('dose_medicamento', where: 'ativo = 1', orderBy: 'horario ASC');
    return rows.map(DoseMedicamento.fromMap).toList();
  }

  Future<int> insert(DoseMedicamento d) async {
    final db = await _db;
    return db.insert('dose_medicamento', d.toMap()..remove('id'));
  }

  Future<void> update(DoseMedicamento d) async {
    final db = await _db;
    await db.update('dose_medicamento', d.toMap(), where: 'id = ?', whereArgs: [d.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('dose_medicamento', where: 'id = ?', whereArgs: [id]);
  }
}
