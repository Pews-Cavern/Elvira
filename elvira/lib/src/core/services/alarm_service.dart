import 'package:alarm/alarm.dart';
import '../models/dose_medicamento.dart';
import '../models/medicamento.dart';
import 'notification_service.dart';
import 'prefs_service.dart';

class AlarmService {
  AlarmService._();


  static final _volumeSettings = VolumeSettings.fade(
    volume: 1.0,
    fadeDuration: const Duration(seconds: 3),
    volumeEnforced: true,
  );

  /// Agenda (ou reagenda) o alarme de uma dose para o próximo disparo válido.
  static Future<void> agendarDose(
    DoseMedicamento dose,
    Medicamento med,
  ) async {
    if (!dose.ativo) return;
    final horario = _proximoDisparo(dose);
    if (horario == null) return;

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: dose.id!,
        dateTime: horario,
        assetAudioPath: (await PrefsService.instance.getSomAlarme()).assetPath,
        volumeSettings: _volumeSettings,
        loopAudio: true,
        vibrate: true,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        notificationSettings: NotificationSettings(
          title: '⏰ Hora do Remédio',
          body: '${med.nome} — ${med.dosagem} ${med.unidade}',
          stopButton: 'Já Tomei',
          icon: 'notification_icon',
        ),
      ),
    );

    // Agendar notificação silenciosa de 15 minutos antes
    await NotificationService.instance.agendarPreNotificacao(
      id: dose.id!,
      horarioDose: horario,
      nomeRemedio: med.nome,
      dosagem: '${med.dosagem} ${med.unidade}',
    );
  }

  /// Cancela o alarme de uma dose específica.
  static Future<void> cancelarDose(int doseId) async {
    await Alarm.stop(doseId);
    await NotificationService.instance.cancelar(doseId);
  }

  /// Cancela todos os alarmes agendados.
  static Future<void> cancelarTodos() async {
    await Alarm.stopAll();
    await NotificationService.instance.cancelarTodas();
  }

  /// Agenda todos os alarmes de um medicamento de uma vez.
  static Future<void> agendarTodosDoMedicamento(
    Medicamento med,
    List<DoseMedicamento> doses,
  ) async {
    for (final dose in doses) {
      await agendarDose(dose, med);
    }
  }

  /// Cancela todos os alarmes de uma lista de doses.
  static Future<void> cancelarDosMedicamento(
    List<DoseMedicamento> doses,
  ) async {
    for (final dose in doses) {
      if (dose.id != null) await cancelarDose(dose.id!);
    }
  }

  /// Calcula o próximo DateTime de disparo para uma dose,
  /// respeitando os dias da semana configurados.
  static DateTime? _proximoDisparo(DoseMedicamento dose) {
    if (dose.diasSemana.isEmpty) return null;
    final partes = dose.horario.split(':');
    final hora = int.tryParse(partes[0]);
    final minuto = int.tryParse(partes.length > 1 ? partes[1] : '0');
    if (hora == null || minuto == null) return null;

    final agora = DateTime.now();
    for (int delta = 0; delta <= 7; delta++) {
      final candidato = DateTime(
        agora.year,
        agora.month,
        agora.day,
        hora,
        minuto,
      ).add(Duration(days: delta));

      // Precisa ser no futuro e no dia da semana correto
      // DateTime.weekday: 1=Seg ... 7=Dom (igual à nossa convenção)
      if (candidato.isAfter(agora) &&
          dose.diasSemana.contains(candidato.weekday)) {
        return candidato;
      }
    }
    return null;
  }
}
