import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/registro_dose.dart';

class RegistroDoseDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<RegistroDose>> getByData(DateTime data) async {
    final db = await _db;
    final inicio = DateTime(data.year, data.month, data.day);
    final fim = inicio.add(const Duration(days: 1));
    final rows = await db.query(
      'registro_dose',
      where: 'data_hora_prevista >= ? AND data_hora_prevista < ?',
      whereArgs: [inicio.toIso8601String(), fim.toIso8601String()],
      orderBy: 'data_hora_prevista ASC',
    );
    return rows.map(RegistroDose.fromMap).toList();
  }

  Future<List<RegistroDose>> getPerdidosNoDia(DateTime data) async {
    final todos = await getByData(data);
    return todos.where((r) => r.status == StatusDose.perdido).toList();
  }

  Future<int> insert(RegistroDose r) async {
    final db = await _db;
    return db.insert('registro_dose', r.toMap()..remove('id'));
  }

  Future<void> updateStatus(int id, StatusDose status) async {
    final db = await _db;
    await db.update(
      'registro_dose',
      {
        'status': status.name,
        'data_hora_registrada': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<RegistroDose>> getHistorico(int days) async {
    final db = await _db;
    final desde = DateTime.now().subtract(Duration(days: days));
    final rows = await db.query(
      'registro_dose',
      where: 'data_hora_prevista >= ?',
      whereArgs: [desde.toIso8601String()],
      orderBy: 'data_hora_prevista DESC',
    );
    return rows.map(RegistroDose.fromMap).toList();
  }
}
