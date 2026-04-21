import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/contato.dart';

class ContatoDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<List<Contato>> getAll() async {
    final db = await _db;
    final rows = await db.query('contato', orderBy: 'ordem_exibicao ASC, nome ASC');
    return rows.map(Contato.fromMap).toList();
  }

  Future<List<Contato>> getEmergencia() async {
    final db = await _db;
    final rows = await db.query(
      'contato',
      where: 'eh_emergencia = 1',
      orderBy: 'ordem_exibicao ASC',
    );
    return rows.map(Contato.fromMap).toList();
  }

  Future<int> insert(Contato c) async {
    final db = await _db;
    final map = c.toMap()..remove('id');
    return db.insert('contato', map);
  }

  Future<void> update(Contato c) async {
    final db = await _db;
    await db.update('contato', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('contato', where: 'id = ?', whereArgs: [id]);
  }
}
