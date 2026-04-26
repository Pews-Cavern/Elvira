import 'package:shared_preferences/shared_preferences.dart';

/// Opções de som disponíveis para o alarme de remédios.
class SomAlarme {
  final String id;
  final String nome;
  final String? assetPath; // null = som padrão do dispositivo

  const SomAlarme({
    required this.id,
    required this.nome,
    this.assetPath,
  });
}

class PrefsService {
  PrefsService._();
  static final instance = PrefsService._();

  static const _keySomAlarme = 'som_alarme';

  /// Lista de sons disponíveis para o alarme.
  static const List<SomAlarme> sonsDisponiveis = [
    SomAlarme(
      id: 'padrao',
      nome: '🔔 Padrão do celular',
      assetPath: null,
    ),
    SomAlarme(
      id: 'pills',
      nome: '💊 Comprimidos (padrão)',
      assetPath: 'assets/sounds/pills.mp3',
    ),
    SomAlarme(
      id: 'alarm_mp3',
      nome: '⏰ Alarme Elvira',
      assetPath: 'assets/sounds/alarm.mp3',
    ),
  ];

  Future<SomAlarme> getSomAlarme() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keySomAlarme) ?? 'pills';
    return sonsDisponiveis.firstWhere(
      (s) => s.id == id,
      orElse: () => sonsDisponiveis[1], // pills como fallback
    );
  }

  Future<void> setSomAlarme(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySomAlarme, id);
  }
}
