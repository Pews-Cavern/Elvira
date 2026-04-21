import 'package:flutter/foundation.dart';
import 'package:alarm/alarm.dart';
import '../models/registro_dose.dart';
import '../db/daos/registro_dose_dao.dart';
import '../db/daos/medicamento_dao.dart';

class DoseProvider extends ChangeNotifier {
  final _registroDao = RegistroDoseDao();
  final _doseDao = DoseDao();

  List<RegistroDose> _registrosHoje = [];
  bool _loading = true;

  List<RegistroDose> get registrosHoje => _registrosHoje;
  bool get loading => _loading;

  List<RegistroDose> get perdidas =>
      _registrosHoje.where((r) => r.status == StatusDose.perdido).toList();

  Future<void> init() async {
    await _gerarRegistrosDoDia();
    _registrosHoje = await _registroDao.getByData(DateTime.now());
    _loading = false;
    notifyListeners();
  }

  Future<void> recarregar() async {
    await _gerarRegistrosDoDia();
    _registrosHoje = await _registroDao.getByData(DateTime.now());
    notifyListeners();
  }

  Future<void> _gerarRegistrosDoDia() async {
    final hoje = DateTime.now();
    final diaAtual = hoje.weekday; // 1=Seg ... 7=Dom
    final doses = await _doseDao.getAll();
    final registrosExistentes = await _registroDao.getByData(hoje);

    for (final dose in doses) {
      if (!dose.diasSemana.contains(diaAtual)) continue;
      final partes = dose.horario.split(':');
      final prevista = DateTime(
        hoje.year,
        hoje.month,
        hoje.day,
        int.parse(partes[0]),
        int.parse(partes[1]),
      );
      final jaExiste = registrosExistentes.any(
        (r) =>
            r.doseId == dose.id! &&
            r.dataHoraPrevista.hour == prevista.hour &&
            r.dataHoraPrevista.minute == prevista.minute,
      );

      if (!jaExiste) {
        final status =
            prevista.isBefore(DateTime.now())
                ? StatusDose.perdido
                : StatusDose.pendente;
        await _registroDao.insert(
          RegistroDose(
            doseId: dose.id!,
            dataHoraPrevista: prevista,
            status: status,
          ),
        );
      }
    }
  }

  /// Marca a dose como tomada e cancela o alarme correspondente.
  Future<void> marcarTomado(int registroId) async {
    await _registroDao.updateStatus(registroId, StatusDose.tomado);

    // Para o alarme se ainda estiver tocando
    final registro = _registrosHoje.firstWhere(
      (r) => r.id == registroId,
      orElse:
          () => RegistroDose(
            id: registroId,
            doseId: -1,
            dataHoraPrevista: DateTime.now(),
            status: StatusDose.tomado,
          ),
    );
    if (registro.doseId > 0) {
      await Alarm.stop(registro.doseId);
    }

    await recarregar();
  }

  /// Adia a dose por 15 minutos: atualiza status e reagenda alarme.
  Future<void> adiarDose(int registroId) async {
    await _registroDao.updateStatus(registroId, StatusDose.adiado);

    // Reagenda o alarme para daqui a 15 minutos
    final registro = _registrosHoje.firstWhere(
      (r) => r.id == registroId,
      orElse:
          () => RegistroDose(
            id: registroId,
            doseId: -1,
            dataHoraPrevista: DateTime.now(),
            status: StatusDose.adiado,
          ),
    );

    if (registro.doseId > 0) {
      final novoHorario = DateTime.now().add(const Duration(minutes: 15));
      // Usa o doseId como ID do alarme — sobrescreve o alarme existente
      final alarmesAtivos = await Alarm.getAlarms();
      final alarmAtual =
          alarmesAtivos.where((a) => a.id == registro.doseId).firstOrNull;

      if (alarmAtual != null) {
        await Alarm.set(
          alarmSettings: alarmAtual.copyWith(dateTime: novoHorario),
        );
      } else {
        // Cria um novo alarme de adiamento se o original não existir mais
        await Alarm.set(
          alarmSettings: AlarmSettings(
            id: registro.doseId,
            dateTime: novoHorario,
            assetAudioPath: null, // usa som padrão do dispositivo
            volumeSettings: VolumeSettings.fade(
              volume: 0.8,
              fadeDuration: const Duration(seconds: 2),
            ),
            loopAudio: true,
            vibrate: true,
            warningNotificationOnKill: false,
            androidFullScreenIntent: true,
            notificationSettings: const NotificationSettings(
              title: '⏰ Lembrete de Remédio',
              body: 'Está na hora de tomar seu remédio!',
              stopButton: 'Já Tomei',
              icon: 'notification_icon',
            ),
          ),
        );
      }
    }

    await recarregar();
  }

  Future<List<RegistroDose>> getHistorico(int days) =>
      _registroDao.getHistorico(days);
}
