import '../models/consulta_medica.dart';
import 'alarm_service.dart';

class ConsultaService {
  ConsultaService._();

  static Future<void> agendarConsulta(ConsultaMedica consulta) async {
    if (consulta.id == null) return;
    await AlarmService.agendarConsulta(consulta);
  }

  static Future<void> cancelarConsulta(int id) async {
    await AlarmService.cancelarConsulta(id);
  }

  static Future<void> cancelarTodas() async {
    // Consultas são canceladas individualmente para não afetar alarmes de remédios.
  }
}