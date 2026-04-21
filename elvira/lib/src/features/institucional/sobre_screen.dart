import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
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
            const SizedBox(height: 8),
            Image.asset('assets/icons/Elvira_Neson.png', height: 120),
            const SizedBox(height: 16),
            Text('Elvira', style: AppTextStyles.h1.copyWith(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              'Launcher acessível para idosos',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botão memorial em destaque
            _MemorialBanner(
              onTap: () => Navigator.pushNamed(context, AppRoutes.memorial),
            ),

            const SizedBox(height: 24),
            _Secao(
              titulo: 'Nossa história',
              conteudo: 'Outro dia, o Google Fotos me jogou um vídeo de 8 anos atrás: eu, com 13 anos, tentando ensinar minha bisavó Elvira a usar o telefoninho Samsung dela. Ela, calma como sempre. E eu ali, explicando, reexplicando, tentando fazer ela entender como atender uma ligação.\n\n'
                  'E mesmo depois de virar dev, continuei vendo gente da minha família — e muita gente mais velha — apanhando pra fazer coisas simples no celular. Tipo atender uma ligação. Ver uma mensagem. Coisa básica.\n\n'
                  'Tentei ajudar como dava: baixei apps que prometiam facilitar a vida de idosos. Resultado? Metade não funcionava. A outra metade era travada por paywall ou simplesmente deixava o celular inútil.\n\n'
                  'Se passaram 6 anos desde que a Dona Elvira se foi. E decidi fazer o que aqueles apps não fizeram: criar algo de verdade.\n\n'
                  'Nasceu o Elvira — um launcher gratuito, 100% offline, open source, feito pensando em gente real, com dificuldade real.\n\n'
                  'Esse app é um tributo à Dona Elvira. Pra garantir que outras Elviras recebam o cuidado digital que merecem — mesmo que nunca tenham pedido.\n\n'
                  'O que começou como ideia virou o meu Projeto Integrador e TCC na Universidade Tuiuti do Paraná.',
            ),
            const SizedBox(height: 16),
            _Secao(
              titulo: 'O projeto',
              conteudo: 'Projeto Integrador V — Análise e Desenvolvimento de Sistemas\n'
                  'Universidade Tuiuti do Paraná — 2026\n\n'
                  'Desenvolvido por Paulo Eduardo Konopka (PewDizinho)',
            ),
            const SizedBox(height: 16),
            _Secao(
              titulo: 'Princípios',
              conteudo: '• Fonte mínima 18sp — legível para todos\n'
                  '• 100% offline — seus dados ficam no celular\n'
                  '• Sem cadastro, sem anúncios, sem rastreamento\n'
                  '• Open Source — licença MIT',
            ),
            const SizedBox(height: 28),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MemorialBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _MemorialBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Text('🕊️', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Em memória de',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Elvira & Nelson',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ver a história deles →',
                    style: AppTextStyles.body.copyWith(color: Colors.white54, fontSize: 16),
                  ),
                ],
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
