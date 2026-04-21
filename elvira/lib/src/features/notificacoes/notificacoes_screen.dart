import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/dose_provider.dart';
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
      body: Consumer<DoseProvider>(
        builder: (_, provider, _) {
          final perdidas = provider.perdidas;
          if (perdidas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text('Sem avisos pendentes', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text('Tudo em dia! 🎉', style: AppTextStyles.body.copyWith(color: AppColors.green)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: perdidas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _NotificacaoTile(registro: perdidas[i]),
          );
        },
      ),
    );
  }
}

class _NotificacaoTile extends StatelessWidget {
  final RegistroDose registro;
  const _NotificacaoTile({required this.registro});

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('HH:mm').format(registro.dataHoraPrevista);
    final data = DateFormat('d/M').format(registro.dataHoraPrevista);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.redMedium, width: 1.5),
      ),
      child: Row(
        children: [
          const Text('❌', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dose perdida', style: AppTextStyles.bodyBold.copyWith(color: AppColors.red)),
                Text('Horário: $hora de $data', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.read<DoseProvider>().marcarTomado(registro.id!),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Tomar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
