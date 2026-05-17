class ConsultaMedica {
  final int? id;
  final String hospitalName;
  final DateTime dateTime;
  final String? mapsUrl;
  final String? notes;

  const ConsultaMedica({
    this.id,
    required this.hospitalName,
    required this.dateTime,
    this.mapsUrl,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'hospital_name': hospitalName,
        'date_time': dateTime.toIso8601String(),
        'maps_url': mapsUrl,
        'notes': notes,
      };

  factory ConsultaMedica.fromMap(Map<String, dynamic> m) => ConsultaMedica(
        id: m['id'] as int?,
        hospitalName: m['hospital_name'] as String,
        dateTime: DateTime.parse(m['date_time'] as String),
        mapsUrl: m['maps_url'] as String?,
        notes: m['notes'] as String?,
      );

  ConsultaMedica copyWith({
    int? id,
    String? hospitalName,
    DateTime? dateTime,
    String? mapsUrl,
    String? notes,
  }) =>
      ConsultaMedica(
        id: id ?? this.id,
        hospitalName: hospitalName ?? this.hospitalName,
        dateTime: dateTime ?? this.dateTime,
        mapsUrl: mapsUrl ?? this.mapsUrl,
        notes: notes ?? this.notes,
      );
}
