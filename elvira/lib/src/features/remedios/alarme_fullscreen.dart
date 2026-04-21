import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/dose_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AlarmeFullscreen extends StatelessWidget {
  const AlarmeFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final nomeRemedio = args?['nome'] as String? ?? 'Remédio';
    final dosagem = args?['dosagem'] as String? ?? '';
    final instrucao = args?['instrucao'] as String? ?? '';
    final hora = args?['hora'] as String? ?? '';
    final registroId = args?['registro_id'] as int?;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⏰ HORA DO REMÉDIO',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(hora, style: AppTextStyles.clock.copyWith(color: Colors.white)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text('💊', style: TextStyle(fontSize: 72)),
              ),
              const SizedBox(height: 28),
              Text(nomeRemedio, style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 26)),
              const SizedBox(height: 8),
              Text(dosagem, style: AppTextStyles.body.copyWith(color: Colors.white70)),
              if (instrucao.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(instrucao, style: AppTextStyles.body.copyWith(color: Colors.white), textAlign: TextAlign.center),
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: () async {
                    if (registroId != null) {
                      await context.read<DoseProvider>().marcarTomado(registroId);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text('✅  JÁ TOMEI', style: AppTextStyles.buttonLarge),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () async {
                    if (registroId != null) {
                      await context.read<DoseProvider>().adiarDose(registroId);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text('⏰  LEMBRAR DEPOIS (15 min)', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
