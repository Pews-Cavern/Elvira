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

  Future<void> cancelar(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelarTodas() async {
    await _plugin.cancelAll();
  }
}
