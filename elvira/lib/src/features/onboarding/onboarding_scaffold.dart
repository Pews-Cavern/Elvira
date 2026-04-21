import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_button.dart';

class OnboardingScaffold extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String emoji;
  final String titulo;
  final String? subtitulo;
  final Widget content;
  final VoidCallback onContinuar;
  final VoidCallback? onVoltar;
  final bool continuarHabilitado;
  final String labelContinuar;

  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.emoji,
    required this.titulo,
    this.subtitulo,
    required this.content,
    required this.onContinuar,
    this.onVoltar,
    this.continuarHabilitado = true,
    this.labelContinuar = 'Continuar →',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Text(
                'Passo $step de $totalSteps',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: step / totalSteps,
                backgroundColor: AppColors.blueLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                borderRadius: BorderRadius.circular(8),
                minHeight: 8,
              ),
              const SizedBox(height: 32),
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(titulo, style: AppTextStyles.h2),
              if (subtitulo != null) ...[
                const SizedBox(height: 8),
                Text(subtitulo!, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ],
              const SizedBox(height: 32),
              Expanded(child: content),
              ElviraButton(
                label: labelContinuar,
                onPressed: continuarHabilitado ? onContinuar : null,
              ),
              const SizedBox(height: 12),
              if (onVoltar != null)
                Center(
                  child: TextButton(
                    onPressed: onVoltar,
                    child: Text('Voltar', style: AppTextStyles.body.copyWith(color: AppColors.textDisabled)),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
