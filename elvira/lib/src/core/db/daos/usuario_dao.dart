import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/usuario.dart';

class UsuarioDao {
  Future<Database> get _db => DatabaseHelper.instance.database;

  Future<Usuario?> get() async {
    final db = await _db;
    final rows = await db.query('usuario', limit: 1);
    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }

  Future<int> upsert(Usuario u) async {
    final db = await _db;
    if (u.id == null) {
      return db.insert('usuario', u.toMap()..remove('id'));
    }
    await db.update('usuario', u.toMap(), where: 'id = ?', whereArgs: [u.id]);
    return u.id!;
  }
}
