import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/consulta_medica.dart';
import '../../../core/providers/consultas_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';

class ConsultasListScreen extends StatelessWidget {
  const ConsultasListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Consultas médicas'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.pushNamed(context, AppRoutes.cuidadorConsultaForm),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Nova',
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<ConsultasProvider>(
        builder: (_, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.consultas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🩺', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma consulta cadastrada',
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastre hospital, data, horário e o link do Maps.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            AppRoutes.cuidadorConsultaForm,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(
                        'Cadastrar primeira consulta',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.consultas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder:
                (_, i) => _ConsultaCard(consulta: provider.consultas[i]),
          );
        },
      ),
    );
  }
}

class _ConsultaCard extends StatelessWidget {
  final ConsultaMedica consulta;

  const _ConsultaCard({required this.consulta});

  Future<void> _abrirMaps(BuildContext context) async {
    final url = consulta.mapsUrl;
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
    ).format(consulta.dateTime);
    final hora = DateFormat('HH:mm').format(consulta.dateTime);
    final antecedencia = consulta.lembreteMinutos >= 120 ? '2 horas' : '1 hora';

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
                      consulta.hospitalName,
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
                      'Aviso com antecedência de $antecedencia',
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
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 58,
                  child: OutlinedButton.icon(
                    onPressed: () => _abrirMaps(context),
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                      'Abrir Maps',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed:
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.cuidadorConsultaForm,
                      arguments: consulta,
                    ),
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                tooltip: 'Editar',
              ),
              IconButton(
                onPressed: () => _confirmarRemocao(context),
                icon: const Icon(Icons.delete_outline, color: AppColors.red),
                tooltip: 'Remover',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarRemocao(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Remover consulta?', style: AppTextStyles.h3),
            content: Text(
              'Esta ação não pode ser desfeita.',
              style: AppTextStyles.body,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ConsultasProvider>().removerConsulta(
                    consulta.id!,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remover'),
              ),
            ],
          ),
    );
  }
}
