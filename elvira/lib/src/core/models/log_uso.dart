enum TipoLog { ligacao, appAberto, telaVisitada, doseRegistrada }

class LogUso {
  final int? id;
  final TipoLog tipo;
  final String detalhe;
  final DateTime dataHora;

  const LogUso({
    this.id,
    required this.tipo,
    required this.detalhe,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'tipo': tipo.name,
        'detalhe': detalhe,
        'data_hora': dataHora.toIso8601String(),
      };

  factory LogUso.fromMap(Map<String, dynamic> m) => LogUso(
        id: m['id'] as int?,
        tipo: TipoLog.values.firstWhere(
          (t) => t.name == m['tipo'],
          orElse: () => TipoLog.telaVisitada,
        ),
        detalhe: m['detalhe'] as String,
        dataHora: DateTime.parse(m['data_hora'] as String),
      );
}
