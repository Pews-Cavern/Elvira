import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Ação ao clicar na notificação (opcional)
      },
    );

    // Solicitação de permissão movida para a WelcomeScreen conforme solicitado pelo usuário
    /*
    _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    */
  }

  /// Agenda uma notificação 15 minutos antes do horário da dose.
  Future<void> agendarPreNotificacao({
    required int id,
    required DateTime horarioDose,
    required String nomeRemedio,
    required String dosagem,
  }) async {
    final dataNotificacao = horarioDose.subtract(const Duration(minutes: 15));

    // Só agenda se a notificação for para o futuro
    if (dataNotificacao.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'pre_dose_channel',
      'Aviso de Medicamento',
      channelDescription: 'Aviso 15 minutos antes de tomar o medicamento',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id: id,
      title: 'Faltam 15 minutos!',
      body: 'Prepare-se para tomar $nomeRemedio ($dosagem).',
      scheduledDate: tz.TZDateTime.from(dataNotificacao, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Agenda um aviso único para uma consulta médica antes do horário marcado.
  Future<void> agendarLembreteConsulta({
    required int id,
    required DateTime horarioConsulta,
    required String hospitalName,
    required int antecedenciaMinutos,
    String? notes,
  }) async {
    final dataNotificacao = horarioConsulta.subtract(Duration(minutes: antecedenciaMinutos));

    if (dataNotificacao.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'consulta_channel',
      'Aviso de Consulta',
      channelDescription: 'Aviso antes da consulta médica',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    final mensagem = notes == null || notes.trim().isEmpty
        ? 'Prepare-se para a consulta em $hospitalName.'
        : 'Prepare-se para a consulta em $hospitalName. Observação: ${notes.trim()}';

    await _plugin.zonedSchedule(
      id: id,
      title: antecedenciaMinutos >= 120 ? 'Consulta em 2 horas' : 'Consulta em 1 hora',
      body: mensagem,
      scheduledDate: tz.TZDateTime.from(dataNotificacao, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelar(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelarTodas() async {
    await _plugin.cancelAll();
  }
}
