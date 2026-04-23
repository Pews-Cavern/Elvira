import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FotoService {
  static Future<Directory> get _dir async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'elvira_fotos'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<List<File>> listar() async {
    final dir = await _dir;
    final entries = await dir.list().where((e) => e is File).cast<File>().toList();
    entries.sort((a, b) => b.path.compareTo(a.path));
    return entries;
  }

  static Future<File> salvar(String tempPath) async {
    final dir = await _dir;
    final nome = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return File(tempPath).copy(p.join(dir.path, nome));
  }

  static Future<void> deletar(File foto) async {
    if (await foto.exists()) await foto.delete();
  }
}
