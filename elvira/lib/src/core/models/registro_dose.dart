enum StatusDose { tomado, perdido, pulado, adiado, pendente }

class RegistroDose {
  final int? id;
  final int doseId;
  final DateTime dataHoraPrevista;
  final DateTime? dataHoraRegistrada;
  final StatusDose status;

  const RegistroDose({
    this.id,
    required this.doseId,
    required this.dataHoraPrevista,
    this.dataHoraRegistrada,
    this.status = StatusDose.pendente,
  });

  static StatusDose _statusFromString(String s) {
    switch (s) {
      case 'tomado':
        return StatusDose.tomado;
      case 'perdido':
        return StatusDose.perdido;
      case 'pulado':
        return StatusDose.pulado;
      case 'adiado':
        return StatusDose.adiado;
      default:
        return StatusDose.pendente;
    }
  }

  static String _statusToString(StatusDose s) => s.name;

  Map<String, dynamic> toMap() => {
        'id': id,
        'dose_id': doseId,
        'data_hora_prevista': dataHoraPrevista.toIso8601String(),
        'data_hora_registrada': dataHoraRegistrada?.toIso8601String(),
        'status': _statusToString(status),
      };

  factory RegistroDose.fromMap(Map<String, dynamic> m) => RegistroDose(
        id: m['id'] as int?,
        doseId: m['dose_id'] as int,
        dataHoraPrevista: DateTime.parse(m['data_hora_prevista'] as String),
        dataHoraRegistrada: m['data_hora_registrada'] != null
            ? DateTime.parse(m['data_hora_registrada'] as String)
            : null,
        status: _statusFromString(m['status'] as String? ?? 'pendente'),
      );

  RegistroDose copyWith({StatusDose? status, DateTime? dataHoraRegistrada}) =>
      RegistroDose(
        id: id,
        doseId: doseId,
        dataHoraPrevista: dataHoraPrevista,
        dataHoraRegistrada: dataHoraRegistrada ?? this.dataHoraRegistrada,
        status: status ?? this.status,
      );
}
