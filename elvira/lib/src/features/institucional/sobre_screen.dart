import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Sobre o Projeto'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text('👴🏼👵🏼', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text('Elvira', style: AppTextStyles.h1.copyWith(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              'Launcher acessível para idosos',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _Secao(
              titulo: 'Nossa história',
              conteudo: 'A Vó Elvira tinha smartphone e não conseguia ligar para a filha sozinha.\n\n'
                  'O Vô Nelson esquecia os remédios porque a letra era pequena demais.\n\n'
                  'O Elvira existe para devolver autonomia a quem tanto nos ensinou a ser independentes.',
            ),
            const SizedBox(height: 20),
            _Secao(
              titulo: 'O projeto',
              conteudo: 'Projeto Integrador V — Análise e Desenvolvimento de Sistemas\n'
                  'Universidade Tuiuti do Paraná — 2026\n\n'
                  'Desenvolvido por Paulo Eduardo Konopka (PewDizinho)',
            ),
            const SizedBox(height: 20),
            _Secao(
              titulo: 'Princípios',
              conteudo: '• Fonte mínima 18sp — legível para todos\n'
                  '• 100% offline — seus dados ficam no celular\n'
                  '• Sem cadastro, sem anúncios, sem rastreamento\n'
                  '• Open Source — licença MIT',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueXLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Versão 1.0.0 • Elvira App © 2026',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final String conteudo;
  const _Secao({required this.titulo, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Text(conteudo, style: AppTextStyles.body.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}
