import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers/contatos_provider.dart';
import '../../core/models/contato.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/widgets/contato_avatar.dart';

class ContatosScreen extends StatelessWidget {
  const ContatosScreen({super.key});

  Future<void> _ligar(String telefone) async {
    HapticFeedback.heavyImpact();
    final uri = Uri(scheme: 'tel', path: telefone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Contatos'),
      body: Consumer<ContatosProvider>(
        builder: (_, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.contatos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📋', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 20),
                    Text('Nenhum contato cadastrado', style: AppTextStyles.h3, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(
                      'Peça ao cuidador para adicionar seus contatos',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.contatos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ContatoTile(
              contato: provider.contatos[i],
              onLigar: () => _ligar(provider.contatos[i].telefone),
            ),
          );
        },
      ),
    );
  }
}

class _ContatoTile extends StatelessWidget {
  final Contato contato;
  final VoidCallback onLigar;

  const _ContatoTile({required this.contato, required this.onLigar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ContatoAvatar(contato: contato, radius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contato.nome, style: AppTextStyles.contactName),
                const SizedBox(height: 2),
                Text(Contato.relacaoLabel(contato.relacao), style: AppTextStyles.contactRelation),
                const SizedBox(height: 2),
                Text(contato.telefone, style: AppTextStyles.contactPhone),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: onLigar,
              child: const SizedBox(
                width: 68,
                height: 68,
                child: Icon(Icons.call, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
