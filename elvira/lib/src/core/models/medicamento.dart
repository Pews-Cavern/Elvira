class Medicamento {
  final int? id;
  final String nome;
  final String dosagem;
  final String unidade;
  final String? instrucaoUso;
  final String? fotoPath;
  final String? dataInicio;
  final String? dataFim;
  final bool ativo;

  const Medicamento({
    this.id,
    required this.nome,
    required this.dosagem,
    this.unidade = 'comprimido',
    this.instrucaoUso,
    this.fotoPath,
    this.dataInicio,
    this.dataFim,
    this.ativo = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'dosagem': dosagem,
        'unidade': unidade,
        'instrucao_uso': instrucaoUso,
        'foto_path': fotoPath,
        'data_inicio': dataInicio,
        'data_fim': dataFim,
        'ativo': ativo ? 1 : 0,
      };

  factory Medicamento.fromMap(Map<String, dynamic> m) => Medicamento(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        dosagem: m['dosagem'] as String,
        unidade: m['unidade'] as String? ?? 'comprimido',
        instrucaoUso: m['instrucao_uso'] as String?,
        fotoPath: m['foto_path'] as String?,
        dataInicio: m['data_inicio'] as String?,
        dataFim: m['data_fim'] as String?,
        ativo: (m['ativo'] as int?) != 0,
      );

  Medicamento copyWith({
    int? id,
    String? nome,
    String? dosagem,
    String? unidade,
    String? instrucaoUso,
    String? fotoPath,
    String? dataInicio,
    String? dataFim,
    bool? ativo,
  }) =>
      Medicamento(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        dosagem: dosagem ?? this.dosagem,
        unidade: unidade ?? this.unidade,
        instrucaoUso: instrucaoUso ?? this.instrucaoUso,
        fotoPath: fotoPath ?? this.fotoPath,
        dataInicio: dataInicio ?? this.dataInicio,
        dataFim: dataFim ?? this.dataFim,
        ativo: ativo ?? this.ativo,
      );
}
