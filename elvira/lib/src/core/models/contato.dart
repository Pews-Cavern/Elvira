class Contato {
  final int? id;
  final String nome;
  final String relacao;
  final String telefone;
  final bool ehEmergencia;
  final int ordemExibicao;

  const Contato({
    this.id,
    required this.nome,
    required this.relacao,
    required this.telefone,
    this.ehEmergencia = false,
    this.ordemExibicao = 0,
  });

  // familiar | medico | cuidador | emergencia
  static const List<String> relacoes = ['familiar', 'medico', 'cuidador', 'emergencia'];

  static String relacaoLabel(String relacao) {
    switch (relacao) {
      case 'familiar':
        return 'Familiar';
      case 'medico':
        return 'Médico(a)';
      case 'cuidador':
        return 'Cuidador(a)';
      case 'emergencia':
        return 'Emergência';
      default:
        return relacao;
    }
  }

  String get initials {
    final parts = nome.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return nome.substring(0, nome.length.clamp(0, 2)).toUpperCase();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'relacao': relacao,
        'telefone': telefone,
        'eh_emergencia': ehEmergencia ? 1 : 0,
        'ordem_exibicao': ordemExibicao,
      };

  factory Contato.fromMap(Map<String, dynamic> m) => Contato(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        relacao: m['relacao'] as String,
        telefone: m['telefone'] as String,
        ehEmergencia: (m['eh_emergencia'] as int?) == 1,
        ordemExibicao: m['ordem_exibicao'] as int? ?? 0,
      );

  Contato copyWith({
    int? id,
    String? nome,
    String? relacao,
    String? telefone,
    bool? ehEmergencia,
    int? ordemExibicao,
  }) =>
      Contato(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        relacao: relacao ?? this.relacao,
        telefone: telefone ?? this.telefone,
        ehEmergencia: ehEmergencia ?? this.ehEmergencia,
        ordemExibicao: ordemExibicao ?? this.ordemExibicao,
      );
}
