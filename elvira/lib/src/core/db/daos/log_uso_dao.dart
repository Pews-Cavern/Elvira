import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/log_uso.dart';

class LogUsoDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<void> registrar(TipoLog tipo, String detalhe) async {
    final db = await _db;
    final log = LogUso(tipo: tipo, detalhe: detalhe, dataHora: DateTime.now());
    await db.insert('log_uso', log.toMap()..remove('id'));
  }

  Future<List<LogUso>> getRecentes({int limit = 50}) async {
    final db = await _db;
    final rows = await db.query(
      'log_uso',
      orderBy: 'data_hora DESC',
      limit: limit,
    );
    return rows.map(LogUso.fromMap).toList();
  }

  Future<List<LogUso>> getByData(DateTime data) async {
    final db = await _db;
    final inicio = DateTime(data.year, data.month, data.day);
    final fim = inicio.add(const Duration(days: 1));
    final rows = await db.query(
      'log_uso',
      where: 'data_hora >= ? AND data_hora < ?',
      whereArgs: [inicio.toIso8601String(), fim.toIso8601String()],
      orderBy: 'data_hora DESC',
    );
    return rows.map(LogUso.fromMap).toList();
  }
}
