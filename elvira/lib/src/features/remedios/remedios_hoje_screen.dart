import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('💊', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 20),
                    Text('Nenhum remédio hoje', style: AppTextStyles.h3, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(
                      'Você está em dia! 🎉',
                      style: AppTextStyles.body.copyWith(color: AppColors.green),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: registros.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, i) {
              final reg = registros[i];
              final med = medProvider.getMedicamento(reg.doseId);
              return _DoseTile(
                registro: reg,
                nomeRemedio: med?.nome ?? 'Remédio',
                dosagemRemedio: med != null ? '${med.dosagem} ${med.unidade}' : '',
                instrucao: med?.instrucaoUso,
                onTomado: () {
                  HapticFeedback.mediumImpact();
                  context.read<DoseProvider>().marcarTomado(reg.id!);
                },
                onAdiar: () {
                  HapticFeedback.lightImpact();
                  context.read<DoseProvider>().adiarDose(reg.id!);
                },
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(hora, style: AppTextStyles.medicTime.copyWith(fontSize: 24)),
              const SizedBox(width: 10),
              Text(_statusIcon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 6),
              Text(_statusLabel, style: AppTextStyles.body.copyWith(color: _borderColor, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💊', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nomeRemedio, style: AppTextStyles.medicName),
                    const SizedBox(height: 2),
                    Text(dosagemRemedio, style: AppTextStyles.medicDetail),
                    if (instrucao != null && instrucao!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(instrucao!, style: AppTextStyles.medicDetail),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!jaFinalizado) ...[
            const SizedBox(height: 14),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton.icon(
                    onPressed: onTomado,
                    icon: const Text('✅', style: TextStyle(fontSize: 22)),
                    label: Text('Já tomei', style: AppTextStyles.button.copyWith(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                if (registro.status == StatusDose.perdido) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: onAdiar,
                      icon: const Text('⏰', style: TextStyle(fontSize: 20)),
                      label: Text('Lembrar daqui 15 min', style: AppTextStyles.button.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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
