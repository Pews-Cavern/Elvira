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

class NotificacoesScreen extends StatelessWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Avisos'),
      body: Consumer2<DoseProvider, MedicamentosProvider>(
        builder: (_, doseProvider, medProvider, _) {
          final perdidas = doseProvider.perdidas;
          if (perdidas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 20),
                    Text('Tudo em dia!', style: AppTextStyles.h3, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(
                      'Você não perdeu nenhum remédio.',
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
            itemCount: perdidas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final reg = perdidas[i];
              final med = medProvider.getMedicamento(reg.doseId);
              return _NotificacaoTile(
                registro: reg,
                nomeRemedio: med?.nome ?? 'Remédio',
                dosagemRemedio: med != null ? '${med.dosagem} ${med.unidade}' : '',
                onTomar: () {
                  HapticFeedback.mediumImpact();
                  doseProvider.marcarTomado(reg.id!);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificacaoTile extends StatelessWidget {
  final RegistroDose registro;
  final String nomeRemedio;
  final String dosagemRemedio;
  final VoidCallback onTomar;

  const _NotificacaoTile({
    required this.registro,
    required this.nomeRemedio,
    required this.dosagemRemedio,
    required this.onTomar,
  });

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('HH:mm').format(registro.dataHoraPrevista);
    final data = DateFormat("d 'de' MMMM", 'pt_BR').format(registro.dataHoraPrevista);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.redMedium, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('❌', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nomeRemedio, style: AppTextStyles.bodyBold.copyWith(color: AppColors.red, fontSize: 20)),
                    if (dosagemRemedio.isNotEmpty)
                      Text(dosagemRemedio, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    Text('$hora — $data', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: onTomar,
              icon: const Text('✅', style: TextStyle(fontSize: 20)),
              label: Text('Registrar como tomado', style: AppTextStyles.button.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
