import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/consulta_medica.dart';

class ConsultaDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<int> insert(ConsultaMedica consulta) async {
    final db = await _db;
    return await db.insert('consulta_medica', consulta.toMap());
  }

  Future<List<ConsultaMedica>> getAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'consulta_medica',
      orderBy: 'date_time ASC',
    );
    return maps.map((m) => ConsultaMedica.fromMap(m)).toList();
  }

  Future<int> update(ConsultaMedica consulta) async {
    final db = await _db;
    return await db.update(
      'consulta_medica',
      consulta.toMap(),
      where: 'id = ?',
      whereArgs: [consulta.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return await db.delete(
      'consulta_medica',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ConsultaMedica?> getById(int id) async {
    final db = await _db;
    final maps = await db.query(
      'consulta_medica',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ConsultaMedica.fromMap(maps.first);
  }
}
