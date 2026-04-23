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
            Image.asset('assets/icons/Elvira_Neson.png', height: 140),
            const SizedBox(height: 20),
            Text('Elvira', style: AppTextStyles.h1.copyWith(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              'Launcher acessível para idosos',
              style: AppTextStyles.body.copyWith(
                fontSize: 22,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            // Botão memorial em destaque
            _MemorialBanner(
              onTap: () => Navigator.pushNamed(context, AppRoutes.memorial),
            ),

            const SizedBox(height: 28),
            _Secao(
              titulo: 'Nossa história',
              conteudo:
                  'A Elvira nasceu a partir de uma realidade comum: a dificuldade que muitas pessoas idosas enfrentam ao usar smartphones, até mesmo para tarefas simples como atender uma ligação ou visualizar uma mensagem.\n\n'
                  'O nome do projeto carrega uma história. Elvira e Nelson foram bisavós do idealizador, Paulo. Pessoas simples, pacientes e presentes — que, como muitos idosos, enfrentavam barreiras ao lidar com tecnologia no dia a dia.\n\n'
                  'Essa vivência direta evidenciou um problema recorrente: mesmo com diversas soluções disponíveis no mercado, a maioria falha em pontos essenciais — seja por não funcionar corretamente, por excesso de complexidade ou por limitar funções básicas atrás de paywalls.\n\n'
                  'Diante disso, surgiu a proposta de fazer diferente: criar uma solução simples, funcional e realmente acessível.\n\n'
                  'Assim nasceu a Elvira — um launcher gratuito, 100% offline e open source, desenvolvido com foco em usabilidade, legibilidade e acessibilidade.\n\n'
                  'Cada detalhe foi pensado para reduzir barreiras digitais e facilitar o uso por pessoas com pouca familiaridade tecnológica.\n\n'
                  'Mais do que um projeto pessoal, a Elvira evoluiu para um projeto acadêmico, tornando-se o Projeto Integrador e Trabalho de Conclusão de Curso na Universidade Tuiuti do Paraná.\n\n'
                  'A Elvira é, acima de tudo, um compromisso com a inclusão digital e com a criação de tecnologia que resolve problemas reais.',
            ),
            const SizedBox(height: 20),
            _Secao(
              titulo: 'O projeto',
              conteudo:
                  'Trabalho de Conclusão de Curso (TCC) — Análise e Desenvolvimento de Sistemas\n'
                  'Universidade Tuiuti do Paraná — 2026\n\n'
                  'Desenvolvido por Paulo Eduardo Konopka (PewDizinho)',
            ),
            const SizedBox(height: 20),
            _Secao(
              titulo: 'Princípios',
              conteudo:
                  '• 100% offline — seus dados ficam no celular\n'
                  '• Sem cadastro, sem anúncios, sem rastreamento\n'
                  '• Open source — licença MIT\n'
                  '• Gratuito — sem paywall ou limitações\n'
                  '• Foco em acessibilidade — pensado para idosos\n'
                  '• Interface simples — sem distrações\n'
                  '• Alta legibilidade — contraste e tipografia claros\n'
                  '• Botões grandes — interação facilitada\n'
                  '• Leve e rápido — funciona em dispositivos antigos\n'
                  '• Privacidade por padrão — nenhum dado coletado',
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.blueXLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Versão 1.0.0 • Elvira App © 2026',
                style: AppTextStyles.body.copyWith(
                  fontSize: 20,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B2A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
        ),
        child: Row(
          children: [
            const Text('🕊️', style: TextStyle(fontSize: 52)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Em memória de',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      color: Colors.white54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Elvira & Nelson',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ver a história deles →',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 20,
                      color: Colors.white60,
                    ),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueLight, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTextStyles.h3.copyWith(fontSize: 24)),
          const SizedBox(height: 12),
          Text(
            conteudo,
            style: AppTextStyles.body.copyWith(fontSize: 20, height: 1.7),
          ),
        ],
      ),
    );
  }
}
