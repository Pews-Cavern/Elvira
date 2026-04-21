import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import 'onboarding_scaffold.dart';

class Step4AccessibilityScreen extends StatefulWidget {
  const Step4AccessibilityScreen({super.key});

  @override
  State<Step4AccessibilityScreen> createState() => _Step4AccessibilityScreenState();
}

class _Step4AccessibilityScreenState extends State<Step4AccessibilityScreen> {
  double _escala = 1.0;
  int _toquesEscala = 0;

  static const _escalas = [1.0, 1.15, 1.3, 1.5, 1.7];

  void _aumentarTexto() {
    setState(() {
      _toquesEscala = (_toquesEscala + 1) % _escalas.length;
      _escala = _escalas[_toquesEscala];
    });
  }

  Future<void> _concluir() async {
    final provider = context.read<UsuarioProvider>();
    await provider.atualizarEscalaFonte(_escala);
    await provider.concluirOnboarding();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 4,
      totalSteps: 4,
      emoji: '🔠',
      titulo: 'Ajuste o tamanho do texto',
      subtitulo: 'Toque no botão para encontrar o tamanho ideal',
      onContinuar: _concluir,
      onVoltar: () => Navigator.pop(context),
      labelContinuar: 'Pronto! Entrar no app',
      content: Column(
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _aumentarTexto,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.blueXLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'A A A',
                    style: TextStyle(
                      fontSize: 24 * _escala,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque para aumentar',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _escalas.asMap().entries.map((e) {
              final ativo = e.key == _toquesEscala;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: ativo ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: ativo ? AppColors.primary : AppColors.blueLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.blueLight),
            ),
            child: Text(
              'Este é o tamanho que o texto vai aparecer no app. Escolha o que fica mais fácil de ler.',
              style: TextStyle(
                fontSize: 18 * _escala,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              textScaler: TextScaler.noScaling,
            ),
          ),
        ],
      ),
    );
  }
}
