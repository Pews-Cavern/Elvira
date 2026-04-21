import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/widgets/elvira_button.dart';

class PrivacidadeScreen extends StatelessWidget {
  const PrivacidadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Privacidade e Termos'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _Badge(emoji: '📴', label: 'Funciona 100% offline', color: AppColors.green),
                  const SizedBox(height: 10),
                  _Badge(emoji: '📱', label: 'Dados ficam no celular', color: AppColors.primary),
                  const SizedBox(height: 24),
                  _Bloco(
                    titulo: 'O que armazenamos',
                    itens: [
                      'Nome, foto e data de nascimento',
                      'Tipo sanguíneo e alergias',
                      'Contatos e telefones',
                      'Medicamentos e horários',
                      'Histórico de doses (local)',
                    ],
                    cor: AppColors.blueXLight,
                    icone: '✅',
                  ),
                  const SizedBox(height: 16),
                  _Bloco(
                    titulo: 'O que NÃO fazemos',
                    itens: [
                      'NÃO enviamos dados para servidores',
                      'NÃO usamos rastreamento ou analytics',
                      'NÃO exibimos anúncios',
                      'NÃO compartilhamos com terceiros',
                      'NÃO exigimos cadastro ou login',
                    ],
                    cor: AppColors.redLight,
                    icone: '🚫',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.blueLight),
                    ),
                    child: Text(
                      'Todos os seus dados ficam armazenados exclusivamente neste dispositivo. Desinstalar o aplicativo apaga todos os dados permanentemente.',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElviraButton(
              label: 'Entendi, continuar',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _Badge({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Text(label, style: AppTextStyles.bodyBold.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _Bloco extends StatelessWidget {
  final String titulo;
  final List<String> itens;
  final Color cor;
  final String icone;
  const _Bloco({required this.titulo, required this.itens, required this.cor, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTextStyles.h3),
          const SizedBox(height: 10),
          ...itens.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(icone, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item, style: AppTextStyles.body)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
