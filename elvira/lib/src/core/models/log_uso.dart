enum TipoLog { ligacao, appAberto, telaVisitada, doseRegistrada }

class LogUso {
  final int? id;
  final int usuarioId;
  final TipoLog tipo;
  final String detalhe;
  final DateTime dataHora;

  const LogUso({
    this.id,
    this.usuarioId = 1,
    required this.tipo,
    required this.detalhe,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario_id': usuarioId,
        'tipo': tipo.name,
        'detalhe': detalhe,
        'data_hora': dataHora.toIso8601String(),
      };

  factory LogUso.fromMap(Map<String, dynamic> m) => LogUso(
        id: m['id'] as int?,
        usuarioId: m['usuario_id'] as int? ?? 1,
        tipo: TipoLog.values.firstWhere(
          (t) => t.name == m['tipo'],
          orElse: () => TipoLog.telaVisitada,
        ),
        detalhe: m['detalhe'] as String,
        dataHora: DateTime.parse(m['data_hora'] as String),
      );
}
