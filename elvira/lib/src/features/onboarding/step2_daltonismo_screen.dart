import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/usuario_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/colorblind_filters.dart';
import 'onboarding_scaffold.dart';

class Step2DaltonismoScreen extends StatelessWidget {
  const Step2DaltonismoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modoAtual = context.watch<UsuarioProvider>().modoDaltonico;
    
    return OnboardingScaffold(
      step: 2,
      totalSteps: 6,
      emoji: '🎨',
      titulo: 'Cores da tela',
      subtitulo: 'Você tem dificuldade em diferenciar alguma cor?',
      continuarHabilitado: true, // Sempre pode continuar, tem "normal" como default
      labelContinuar: 'Avançar',
      onContinuar: () => Navigator.pushNamed(context, AppRoutes.step3),
      onVoltar: () => Navigator.pop(context),
      content: Column(
        children: ColorBlindMode.values.map((modo) {
          final selecionado = modoAtual == modo.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.read<UsuarioProvider>().definirModoDaltonico(modo.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: selecionado ? AppColors.blueXLight : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selecionado ? AppColors.primary : const Color(0xFFDCDCDC),
                    width: selecionado ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selecionado ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: selecionado ? AppColors.primary : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        modo.label,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: selecionado ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
