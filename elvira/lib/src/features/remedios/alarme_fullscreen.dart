import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
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
    final alarmId = args?['alarm_id'] as int?;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
                  - MediaQuery.of(context).padding.top
                  - MediaQuery.of(context).padding.bottom
                  - 64,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    '⏰ HORA DO REMÉDIO',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(hora, style: AppTextStyles.clock.copyWith(color: Colors.white, fontSize: 72)),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text('💊', style: TextStyle(fontSize: 80)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    nomeRemedio,
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  if (dosagem.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      dosagem,
                      style: AppTextStyles.body.copyWith(color: Colors.white70, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (instrucao.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        instrucao,
                        style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const Spacer(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 76,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        await Alarm.stopAll();
                        if (alarmId != null) {
                          await Alarm.stop(alarmId);
                        }
                        if (registroId != null) {
                          await context.read<DoseProvider>().marcarTomado(registroId);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                      ),
                      child: Text('✅  JÁ TOMEI', style: AppTextStyles.buttonLarge),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 68,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        await Alarm.stopAll();
                        if (alarmId != null) {
                          await Alarm.stop(alarmId);
                        }
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
                      child: Text('⏰  Lembrar daqui 15 min', style: AppTextStyles.button),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
