import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/medicamentos_provider.dart';
import '../../../core/models/medicamento.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/routes/app_routes.dart';

class MedicamentosListScreen extends StatelessWidget {
  const MedicamentosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Medicamentos'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cuidadorMedicamentoForm),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Novo', style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
      body: Consumer<MedicamentosProvider>(
        builder: (_, provider, _) {
          if (provider.loading) return const Center(child: CircularProgressIndicator());
          if (provider.medicamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💊', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text('Nenhum medicamento cadastrado', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cuidadorMedicamentoForm),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text('Adicionar primeiro', style: AppTextStyles.button.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.medicamentos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _MedTile(
              med: provider.medicamentos[i],
              doses: provider.dosesDoMedicamento(provider.medicamentos[i].id!),
            ),
          );
        },
      ),
    );
  }
}

class _MedTile extends StatelessWidget {
  final Medicamento med;
  final List doses;

  const _MedTile({required this.med, required this.doses});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Row(
        children: [
          const Text('💊', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.nome, style: AppTextStyles.bodyBold),
                Text('${med.dosagem} ${med.unidade}', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                if (doses.isNotEmpty)
                  Text('${doses.length} horário(s)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.cuidadorMedicamentoForm,
                  arguments: med,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.red),
                onPressed: () => _confirmarRemover(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarRemover(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remover ${med.nome}?', style: AppTextStyles.h3),
        content: Text('Esta ação não pode ser desfeita.', style: AppTextStyles.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<MedicamentosProvider>().removerMedicamento(med.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}
