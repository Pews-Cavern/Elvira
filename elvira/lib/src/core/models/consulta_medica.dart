class ConsultaMedica {
  final int? id;
  final int usuarioId;
  final String hospitalName;
  final DateTime dateTime;
  final String? mapsUrl;
  final String? notes;
  final int lembreteMinutos;

  const ConsultaMedica({
    this.id,
    this.usuarioId = 1,
    required this.hospitalName,
    required this.dateTime,
    this.mapsUrl,
    this.notes,
    this.lembreteMinutos = 60,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'usuario_id': usuarioId,
    'hospital_name': hospitalName,
    'date_time': dateTime.toIso8601String(),
    'maps_url': mapsUrl,
    'notes': notes,
    'lembrete_minutos': lembreteMinutos,
  };

  factory ConsultaMedica.fromMap(Map<String, dynamic> m) => ConsultaMedica(
    id: m['id'] as int?,
    usuarioId: m['usuario_id'] as int? ?? 1,
    hospitalName: m['hospital_name'] as String,
    dateTime: DateTime.parse(m['date_time'] as String),
    mapsUrl: m['maps_url'] as String?,
    notes: m['notes'] as String?,
    lembreteMinutos: m['lembrete_minutos'] as int? ?? 60,
  );

  ConsultaMedica copyWith({
    int? id,
    int? usuarioId,
    String? hospitalName,
    DateTime? dateTime,
    String? mapsUrl,
    String? notes,
    int? lembreteMinutos,
  }) => ConsultaMedica(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    hospitalName: hospitalName ?? this.hospitalName,
    dateTime: dateTime ?? this.dateTime,
    mapsUrl: mapsUrl ?? this.mapsUrl,
    notes: notes ?? this.notes,
    lembreteMinutos: lembreteMinutos ?? this.lembreteMinutos,
  );
}
