import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/consultas_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';

class ConsultasHojeScreen extends StatelessWidget {
  const ConsultasHojeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Minhas Consultas'),
      body: Consumer<ConsultasProvider>(
        builder: (_, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final consultas = provider.consultas;
          if (consultas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🩺', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 20),
                    Text(
                      'Nenhuma consulta agendada',
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'As consultas cadastradas pelo cuidador aparecerão aqui.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: consultas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder:
                (_, index) => _ConsultaTile(consulta: consultas[index]),
          );
        },
      ),
    );
  }
}

class _ConsultaTile extends StatelessWidget {
  final dynamic consulta;

  const _ConsultaTile({required this.consulta});

  Future<void> _abrirMaps(BuildContext context) async {
    final url = consulta.mapsUrl as String?;
    if (url == null || url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta consulta não tem link de Maps cadastrado.'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url.trim());
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O link de Maps está inválido.')),
      );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final data = DateFormat(
      "d 'de' MMMM yyyy",
      'pt_BR',
    ).format(consulta.dateTime as DateTime);
    final hora = DateFormat('HH:mm').format(consulta.dateTime as DateTime);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blueLight, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🩺', style: TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consulta.hospitalName as String,
                      style: AppTextStyles.bodyBold.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$data • $hora',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aviso com antecedência de ${consulta.lembreteMinutos ~/ 60}h',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                    if (consulta.notes != null &&
                        consulta.notes!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          consulta.notes!,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: OutlinedButton.icon(
              onPressed: () => _abrirMaps(context),
              icon: const Icon(Icons.map_outlined),
              label: Text(
                'Abrir Maps',
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
