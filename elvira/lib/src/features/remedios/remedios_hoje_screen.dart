import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/dose_provider.dart';
import '../../core/providers/medicamentos_provider.dart';
import '../../core/models/registro_dose.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';

class RemediosHojeScreen extends StatefulWidget {
  const RemediosHojeScreen({super.key});

  @override
  State<RemediosHojeScreen> createState() => _RemediosHojeScreenState();
}

class _RemediosHojeScreenState extends State<RemediosHojeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoseProvider>().recarregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Meus Remédios'),
      body: Consumer2<DoseProvider, MedicamentosProvider>(
        builder: (_, doseProvider, medProvider, _) {
          if (doseProvider.loading) return const Center(child: CircularProgressIndicator());

          final registros = doseProvider.registrosHoje;
          if (registros.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💊', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text('Nenhum remédio hoje', style: AppTextStyles.h3),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: registros.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final reg = registros[i];
              final med = medProvider.getMedicamento(reg.doseId);
              return _DoseTile(
                registro: reg,
                nomeRemedio: med?.nome ?? 'Remédio',
                dosagemRemedio: med != null ? '${med.dosagem} ${med.unidade}' : '',
                instrucao: med?.instrucaoUso,
                onTomado: () => context.read<DoseProvider>().marcarTomado(reg.id!),
                onAdiar: () => context.read<DoseProvider>().adiarDose(reg.id!),
              );
            },
          );
        },
      ),
    );
  }
}

class _DoseTile extends StatelessWidget {
  final RegistroDose registro;
  final String nomeRemedio;
  final String dosagemRemedio;
  final String? instrucao;
  final VoidCallback onTomado;
  final VoidCallback onAdiar;

  const _DoseTile({
    required this.registro,
    required this.nomeRemedio,
    required this.dosagemRemedio,
    this.instrucao,
    required this.onTomado,
    required this.onAdiar,
  });

  Color get _borderColor {
    switch (registro.status) {
      case StatusDose.tomado:
        return AppColors.green;
      case StatusDose.perdido:
        return AppColors.red;
      case StatusDose.adiado:
        return AppColors.amber;
      default:
        return AppColors.accentBlue;
    }
  }

  Color get _bgColor {
    switch (registro.status) {
      case StatusDose.tomado:
        return const Color(0xFFE8F8F2);
      case StatusDose.perdido:
        return AppColors.redLight;
      case StatusDose.adiado:
        return const Color(0xFFFFF8EC);
      default:
        return Colors.white;
    }
  }

  String get _statusIcon {
    switch (registro.status) {
      case StatusDose.tomado:
        return '✅';
      case StatusDose.perdido:
        return '❌';
      case StatusDose.adiado:
        return '⏰';
      default:
        return '🕒';
    }
  }

  String get _statusLabel {
    switch (registro.status) {
      case StatusDose.tomado:
        return 'Já tomado';
      case StatusDose.perdido:
        return 'Atrasado';
      case StatusDose.adiado:
        return 'Adiado';
      default:
        return 'Próximo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('HH:mm').format(registro.dataHoraPrevista);
    final jaFinalizado = registro.status == StatusDose.tomado || registro.status == StatusDose.pulado;

    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(hora, style: AppTextStyles.medicTime),
              const SizedBox(width: 10),
              Text(_statusIcon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(_statusLabel, style: AppTextStyles.body.copyWith(color: _borderColor)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('💊', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nomeRemedio, style: AppTextStyles.medicName),
                    Text(dosagemRemedio, style: AppTextStyles.medicDetail),
                    if (instrucao != null)
                      Text(instrucao!, style: AppTextStyles.medicDetail),
                  ],
                ),
              ),
            ],
          ),
          if (!jaFinalizado) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTomado,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('✅ Já tomei', style: AppTextStyles.button.copyWith(color: Colors.white)),
                  ),
                ),
                if (registro.status == StatusDose.perdido) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAdiar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Tomar agora', style: AppTextStyles.button.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
