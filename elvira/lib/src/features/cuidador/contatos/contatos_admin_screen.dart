import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/contatos_provider.dart';
import '../../../core/models/contato.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/contato_avatar.dart';
import '../../../core/routes/app_routes.dart';

class ContatosAdminScreen extends StatelessWidget {
  const ContatosAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Contatos'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cuidadorContatoForm),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: Text('Novo', style: AppTextStyles.button),
      ),
      body: Consumer<ContatosProvider>(
        builder: (_, provider, _) {
          if (provider.loading) return const Center(child: CircularProgressIndicator());
          if (provider.contatos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('👥', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text('Nenhum contato cadastrado', style: AppTextStyles.h3),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.contatos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _AdminContatoTile(
              contato: provider.contatos[i],
              onEditar: () => Navigator.pushNamed(context, AppRoutes.cuidadorContatoForm, arguments: provider.contatos[i]),
              onRemover: () => _confirmarRemover(context, provider.contatos[i], provider),
            ),
          );
        },
      ),
    );
  }

  void _confirmarRemover(BuildContext context, Contato c, ContatosProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remover ${c.nome}?', style: AppTextStyles.h3),
        content: Text('Esta ação não pode ser desfeita.', style: AppTextStyles.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              provider.remover(c.id!);
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

class _AdminContatoTile extends StatelessWidget {
  final Contato contato;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const _AdminContatoTile({required this.contato, required this.onEditar, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Row(
        children: [
          ContatoAvatar(contato: contato, radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contato.nome, style: AppTextStyles.bodyBold),
                Text(Contato.relacaoLabel(contato.relacao), style: AppTextStyles.contactRelation),
                Text(contato.telefone, style: AppTextStyles.contactPhone),
                if (contato.ehEmergencia)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.redLight, borderRadius: BorderRadius.circular(8)),
                    child: Text('Emergência', style: AppTextStyles.bodySmall.copyWith(color: AppColors.red)),
                  ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primary), onPressed: onEditar),
          IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.red), onPressed: onRemover),
        ],
      ),
    );
  }
}
