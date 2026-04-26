class Usuario {
  final int? id;
  final String nome;
  final String genero;
  final String? fotoPath;
  final String? dataNascimento;
  final String? tipoSanguineo;
  final String? alergias;
  final String? condicoesSaude;
  final String? pinCuidador;
  final String? planoSaude;
  final double tamanhoFonteBase;
  final bool onboardingCompleto;

  const Usuario({
    this.id,
    required this.nome,
    this.genero = 'nao_informado',
    this.fotoPath,
    this.dataNascimento,
    this.tipoSanguineo,
    this.alergias,
    this.condicoesSaude,
    this.pinCuidador,
    this.planoSaude,
    this.tamanhoFonteBase = 1.0,
    this.onboardingCompleto = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'genero': genero,
        'foto_path': fotoPath,
        'data_nascimento': dataNascimento,
        'tipo_sanguineo': tipoSanguineo,
        'alergias': alergias,
        'condicoes_saude': condicoesSaude,
        'pin_cuidador': pinCuidador,
        'plano_saude': planoSaude,
        'tamanho_fonte_base': tamanhoFonteBase,
        'onboarding_completo': onboardingCompleto ? 1 : 0,
      };

  factory Usuario.fromMap(Map<String, dynamic> m) => Usuario(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        genero: m['genero'] as String? ?? 'nao_informado',
        fotoPath: m['foto_path'] as String?,
        dataNascimento: m['data_nascimento'] as String?,
        tipoSanguineo: m['tipo_sanguineo'] as String?,
        alergias: m['alergias'] as String?,
        condicoesSaude: m['condicoes_saude'] as String?,
        pinCuidador: m['pin_cuidador'] as String?,
        planoSaude: m['plano_saude'] as String?,
        tamanhoFonteBase: (m['tamanho_fonte_base'] as num?)?.toDouble() ?? 1.0,
        onboardingCompleto: (m['onboarding_completo'] as int?) == 1,
      );

  Usuario copyWith({
    int? id,
    String? nome,
    String? genero,
    String? fotoPath,
    String? dataNascimento,
    String? tipoSanguineo,
    String? alergias,
    String? condicoesSaude,
    String? pinCuidador,
    String? planoSaude,
    double? tamanhoFonteBase,
    bool? onboardingCompleto,
  }) =>
      Usuario(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        genero: genero ?? this.genero,
        fotoPath: fotoPath ?? this.fotoPath,
        dataNascimento: dataNascimento ?? this.dataNascimento,
        tipoSanguineo: tipoSanguineo ?? this.tipoSanguineo,
        alergias: alergias ?? this.alergias,
        condicoesSaude: condicoesSaude ?? this.condicoesSaude,
        pinCuidador: pinCuidador ?? this.pinCuidador,
        planoSaude: planoSaude ?? this.planoSaude,
        tamanhoFonteBase: tamanhoFonteBase ?? this.tamanhoFonteBase,
        onboardingCompleto: onboardingCompleto ?? this.onboardingCompleto,
      );
}
