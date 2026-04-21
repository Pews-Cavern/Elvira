class DoseMedicamento {
  final int? id;
  final int medicamentoId;
  final String horario; // HH:mm
  final List<int> diasSemana; // 1=Seg ... 7=Dom
  final bool ativo;

  const DoseMedicamento({
    this.id,
    required this.medicamentoId,
    required this.horario,
    this.diasSemana = const [1, 2, 3, 4, 5, 6, 7],
    this.ativo = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'medicamento_id': medicamentoId,
        'horario': horario,
        'dias_semana': diasSemana.join(','),
        'ativo': ativo ? 1 : 0,
      };

  factory DoseMedicamento.fromMap(Map<String, dynamic> m) => DoseMedicamento(
        id: m['id'] as int?,
        medicamentoId: m['medicamento_id'] as int,
        horario: m['horario'] as String,
        diasSemana: (m['dias_semana'] as String)
            .split(',')
            .where((s) => s.isNotEmpty)
            .map(int.parse)
            .toList(),
        ativo: (m['ativo'] as int?) != 0,
      );

  DoseMedicamento copyWith({
    int? id,
    int? medicamentoId,
    String? horario,
    List<int>? diasSemana,
    bool? ativo,
  }) =>
      DoseMedicamento(
        id: id ?? this.id,
        medicamentoId: medicamentoId ?? this.medicamentoId,
        horario: horario ?? this.horario,
        diasSemana: diasSemana ?? this.diasSemana,
        ativo: ativo ?? this.ativo,
      );
}
