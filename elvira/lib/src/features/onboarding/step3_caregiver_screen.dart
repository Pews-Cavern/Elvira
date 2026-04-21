import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import 'onboarding_scaffold.dart';

class Step3CaregiverScreen extends StatefulWidget {
  const Step3CaregiverScreen({super.key});

  @override
  State<Step3CaregiverScreen> createState() => _Step3CaregiverScreenState();
}

class _Step3CaregiverScreenState extends State<Step3CaregiverScreen> {
  bool? _temCuidador;
  final _pinController = TextEditingController();
  final _pinFocus = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (_temCuidador == null) return;
    final provider = context.read<UsuarioProvider>();
    if (_temCuidador! && _pinController.text.length == 4) {
      await provider.definirPin(_pinController.text);
    }
    if (mounted) Navigator.pushNamed(context, AppRoutes.step4);
  }

  bool get _podeContinuar {
    if (_temCuidador == null) return false;
    if (_temCuidador! && _pinController.text.length != 4) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      totalSteps: 4,
      emoji: '🤝',
      titulo: 'Alguém vai te ajudar?',
      subtitulo: 'Filho, filha, cuidador ou familiar',
      onContinuar: _continuar,
      onVoltar: () => Navigator.pop(context),
      continuarHabilitado: _podeContinuar,
      content: Column(
        children: [
          _Opcao(
            emoji: '👨‍👩‍👧',
            titulo: 'Sim, tenho alguém',
            subtitulo: 'Vamos configurar uma senha de cuidador',
            selecionado: _temCuidador == true,
            onTap: () => setState(() => _temCuidador = true),
          ),
          const SizedBox(height: 12),
          _Opcao(
            emoji: '🙋',
            titulo: 'Não, sou eu mesmo',
            subtitulo: 'Você configura tudo sozinho',
            selecionado: _temCuidador == false,
            onTap: () => setState(() => _temCuidador = false),
          ),
          if (_temCuidador == true) ...[
            const SizedBox(height: 24),
            Text('Crie um PIN de 4 dígitos para o cuidador:', style: AppTextStyles.body),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: _pinController,
              builder: (_, _, _) => TextField(
                controller: _pinController,
                focusNode: _pinFocus,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '• • • •',
                  counterText: '',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Opcao extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final bool selecionado;
  final VoidCallback onTap;

  const _Opcao({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.blueXLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionado ? AppColors.primary : AppColors.blueLight,
            width: selecionado ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppTextStyles.bodyBold),
                  Text(subtitulo, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
