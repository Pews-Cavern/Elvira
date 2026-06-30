import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'elvira.db';
  static const _dbVersion = 11;

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
        tem_cuidador INTEGER NOT NULL DEFAULT 0,
        modo_daltonico TEXT NOT NULL DEFAULT 'normal',
        plano_saude TEXT,
        tamanho_fonte_base REAL NOT NULL DEFAULT 1.0,
        onboarding_completo INTEGER NOT NULL DEFAULT 0,
        apps_ocultos TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE contato (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL DEFAULT 1,
        nome TEXT NOT NULL,
        relacao TEXT NOT NULL,
        telefone TEXT NOT NULL,
        foto_path TEXT,
        eh_emergencia INTEGER NOT NULL DEFAULT 0,
        eh_favorito INTEGER NOT NULL DEFAULT 0,
        ordem_exibicao INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE medicamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL DEFAULT 1,
        nome TEXT NOT NULL,
        dosagem TEXT NOT NULL,
        unidade TEXT NOT NULL DEFAULT 'comprimido',
        instrucao_uso TEXT,
        foto_path TEXT,
        data_inicio TEXT,
        data_fim TEXT,
        ativo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
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
        usuario_id INTEGER NOT NULL DEFAULT 1,
        tipo TEXT NOT NULL,
        detalhe TEXT NOT NULL,
        data_hora TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE consulta_medica (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL DEFAULT 1,
        hospital_name TEXT NOT NULL,
        date_time TEXT NOT NULL,
        maps_url TEXT,
        notes TEXT,
        lembrete_minutos INTEGER NOT NULL DEFAULT 60,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE usuario ADD COLUMN plano_saude TEXT;');
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE medicamento ADD COLUMN data_inicio TEXT;',
        );
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE medicamento ADD COLUMN data_fim TEXT;');
      } catch (_) {}
    }
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE usuario ADD COLUMN plano_saude TEXT;');
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE medicamento ADD COLUMN data_inicio TEXT;',
        );
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE medicamento ADD COLUMN data_fim TEXT;');
      } catch (_) {}
    }
    if (oldVersion < 4) {
      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS consulta_medica (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hospital_name TEXT NOT NULL,
            date_time TEXT NOT NULL,
            maps_url TEXT,
            notes TEXT,
            lembrete_minutos INTEGER NOT NULL DEFAULT 60
          )
        ''');
      } catch (_) {}
    }
    if (oldVersion < 5) {
      try {
        await db.execute(
          'ALTER TABLE consulta_medica ADD COLUMN lembrete_minutos INTEGER NOT NULL DEFAULT 60;',
        );
      } catch (_) {}
    }
    if (oldVersion < 6) {
      try {
        await db.execute(
          'ALTER TABLE contato ADD COLUMN foto_path TEXT;',
        );
      } catch (_) {}
    }
    if (oldVersion < 7) {
      try {
        await db.execute(
          'ALTER TABLE contato ADD COLUMN eh_favorito INTEGER NOT NULL DEFAULT 0;',
        );
      } catch (_) {}
    }
    if (oldVersion < 8) {
      // Adiciona usuario_id FK em contato, medicamento, consulta_medica e log_uso.
      // SQLite não permite ALTER TABLE para adicionar FK, então recria as tabelas.
      try {
        await db.execute('''
          CREATE TABLE contato_v8 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL DEFAULT 1,
            nome TEXT NOT NULL,
            relacao TEXT NOT NULL,
            telefone TEXT NOT NULL,
            foto_path TEXT,
            eh_emergencia INTEGER NOT NULL DEFAULT 0,
            eh_favorito INTEGER NOT NULL DEFAULT 0,
            ordem_exibicao INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          INSERT INTO contato_v8 (id, usuario_id, nome, relacao, telefone, foto_path, eh_emergencia, eh_favorito, ordem_exibicao)
          SELECT id, 1, nome, relacao, telefone, foto_path, eh_emergencia, eh_favorito, ordem_exibicao FROM contato
        ''');
        await db.execute('DROP TABLE contato');
        await db.execute('ALTER TABLE contato_v8 RENAME TO contato');
      } catch (_) {}

      try {
        await db.execute('''
          CREATE TABLE medicamento_v8 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL DEFAULT 1,
            nome TEXT NOT NULL,
            dosagem TEXT NOT NULL,
            unidade TEXT NOT NULL DEFAULT 'comprimido',
            instrucao_uso TEXT,
            foto_path TEXT,
            data_inicio TEXT,
            data_fim TEXT,
            ativo INTEGER NOT NULL DEFAULT 1,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          INSERT INTO medicamento_v8 (id, usuario_id, nome, dosagem, unidade, instrucao_uso, foto_path, data_inicio, data_fim, ativo)
          SELECT id, 1, nome, dosagem, unidade, instrucao_uso, foto_path, data_inicio, data_fim, ativo FROM medicamento
        ''');
        await db.execute('DROP TABLE medicamento');
        await db.execute('ALTER TABLE medicamento_v8 RENAME TO medicamento');
      } catch (_) {}

      try {
        await db.execute('''
          CREATE TABLE consulta_medica_v8 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL DEFAULT 1,
            hospital_name TEXT NOT NULL,
            date_time TEXT NOT NULL,
            maps_url TEXT,
            notes TEXT,
            lembrete_minutos INTEGER NOT NULL DEFAULT 60,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          INSERT INTO consulta_medica_v8 (id, usuario_id, hospital_name, date_time, maps_url, notes, lembrete_minutos)
          SELECT id, 1, hospital_name, date_time, maps_url, notes, lembrete_minutos FROM consulta_medica
        ''');
        await db.execute('DROP TABLE consulta_medica');
        await db.execute('ALTER TABLE consulta_medica_v8 RENAME TO consulta_medica');
      } catch (_) {}

      try {
        await db.execute('''
          CREATE TABLE log_uso_v8 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL DEFAULT 1,
            tipo TEXT NOT NULL,
            detalhe TEXT NOT NULL,
            data_hora TEXT NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          INSERT INTO log_uso_v8 (id, usuario_id, tipo, detalhe, data_hora)
          SELECT id, 1, tipo, detalhe, data_hora FROM log_uso
        ''');
        await db.execute('DROP TABLE log_uso');
        await db.execute('ALTER TABLE log_uso_v8 RENAME TO log_uso');
      } catch (_) {}
    }
    if (oldVersion < 9) {
      try {
        await db.execute(
          'ALTER TABLE usuario ADD COLUMN tem_cuidador INTEGER NOT NULL DEFAULT 0;',
        );
      } catch (_) {}
    }
    if (oldVersion < 10) {
      try {
        await db.execute(
          "ALTER TABLE usuario ADD COLUMN modo_daltonico TEXT NOT NULL DEFAULT 'normal';",
        );
      } catch (_) {}
    }
    if (oldVersion < 11) {
      try {
        await db.execute(
          "ALTER TABLE usuario ADD COLUMN apps_ocultos TEXT NOT NULL DEFAULT '';",
        );
      } catch (_) {}
    }
  }
}
