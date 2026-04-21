import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers/contatos_provider.dart';
import '../../core/models/contato.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/widgets/contato_avatar.dart';

class EmergenciaScreen extends StatelessWidget {
  const EmergenciaScreen({super.key});

  Future<void> _ligar(String telefone) async {
    final uri = Uri(scheme: 'tel', path: telefone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redLight,
      appBar: const ElviraAppBar(title: 'Emergência', backgroundColor: AppColors.red),
      body: Consumer<ContatosProvider>(
        builder: (_, provider, _) {
          final emergencia = provider.emergencia;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // SOS central
                GestureDetector(
                  onTap: emergencia.isNotEmpty ? () => _ligar(emergencia.first.telefone) : null,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.red.withAlpha(100), blurRadius: 24, spreadRadius: 8)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SOS', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 36)),
                        const SizedBox(height: 4),
                        Text('LIGAR AGORA', style: AppTextStyles.bodySmall.copyWith(color: Colors.white, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Precisa de ajuda?', style: AppTextStyles.h2.copyWith(color: AppColors.red)),
                const SizedBox(height: 8),
                Text(
                  'Toque no botão grande para acionar emergência\nou escolha um contato abaixo',
                  style: AppTextStyles.body.copyWith(color: AppColors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Contatos de emergência
                if (emergencia.isNotEmpty)
                  ...emergencia.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _EmergenciaTile(contato: c, onLigar: () => _ligar(c.telefone)),
                      ))
                else ...[
                  // SAMU sempre visível
                  _EmergenciaTile(
                    contato: const Contato(nome: 'SAMU', relacao: 'emergencia', telefone: '192'),
                    onLigar: () => _ligar('192'),
                  ),
                  const SizedBox(height: 10),
                  _EmergenciaTile(
                    contato: const Contato(nome: 'Bombeiros', relacao: 'emergencia', telefone: '193'),
                    onLigar: () => _ligar('193'),
                  ),
                ],
                const SizedBox(height: 10),
                _EmergenciaTile(
                  contato: const Contato(nome: 'SAMU', relacao: 'emergencia', telefone: '192'),
                  onLigar: () => _ligar('192'),
                  fixedLabel: '192',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmergenciaTile extends StatelessWidget {
  final Contato contato;
  final VoidCallback onLigar;
  final String? fixedLabel;

  const _EmergenciaTile({required this.contato, required this.onLigar, this.fixedLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.redMedium, width: 1.5),
      ),
      child: Row(
        children: [
          ContatoAvatar(contato: contato, radius: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contato.nome, style: AppTextStyles.contactName),
                Text(contato.telefone, style: AppTextStyles.contactPhone),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onLigar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: fixedLabel != null
                ? Text(fixedLabel!, style: AppTextStyles.bodyBold.copyWith(color: Colors.white))
                : const Icon(Icons.call, size: 24),
          ),
        ],
      ),
    );
  }
}
