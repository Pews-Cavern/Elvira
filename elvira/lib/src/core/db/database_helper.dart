import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'elvira.db';
  static const _dbVersion = 3;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        genero TEXT NOT NULL DEFAULT 'nao_informado',
        foto_path TEXT,
        data_nascimento TEXT,
        tipo_sanguineo TEXT,
        alergias TEXT,
        condicoes_saude TEXT,
        pin_cuidador TEXT,
        plano_saude TEXT,
        tamanho_fonte_base REAL NOT NULL DEFAULT 1.0,
        onboarding_completo INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE contato (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        relacao TEXT NOT NULL,
        telefone TEXT NOT NULL,
        eh_emergencia INTEGER NOT NULL DEFAULT 0,
        ordem_exibicao INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE medicamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        dosagem TEXT NOT NULL,
        unidade TEXT NOT NULL DEFAULT 'comprimido',
        instrucao_uso TEXT,
        foto_path TEXT,
        data_inicio TEXT,
        data_fim TEXT,
        ativo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE dose_medicamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicamento_id INTEGER NOT NULL,
        horario TEXT NOT NULL,
        dias_semana TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7',
        ativo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (medicamento_id) REFERENCES medicamento(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE registro_dose (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dose_id INTEGER NOT NULL,
        data_hora_prevista TEXT NOT NULL,
        data_hora_registrada TEXT,
        status TEXT NOT NULL DEFAULT 'pendente',
        FOREIGN KEY (dose_id) REFERENCES dose_medicamento(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE log_uso (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        detalhe TEXT NOT NULL,
        data_hora TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try { await db.execute('ALTER TABLE usuario ADD COLUMN plano_saude TEXT;'); } catch (_) {}
      try { await db.execute('ALTER TABLE medicamento ADD COLUMN data_inicio TEXT;'); } catch (_) {}
      try { await db.execute('ALTER TABLE medicamento ADD COLUMN data_fim TEXT;'); } catch (_) {}
    }
    if (oldVersion < 3) {
      try { await db.execute('ALTER TABLE usuario ADD COLUMN plano_saude TEXT;'); } catch (_) {}
      try { await db.execute('ALTER TABLE medicamento ADD COLUMN data_inicio TEXT;'); } catch (_) {}
      try { await db.execute('ALTER TABLE medicamento ADD COLUMN data_fim TEXT;'); } catch (_) {}
    }
  }
}
