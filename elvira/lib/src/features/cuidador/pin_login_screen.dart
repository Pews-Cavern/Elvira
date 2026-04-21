import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/routes/app_routes.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _pin = '';
  bool _erro = false;

  static const _teclas = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'DEL'];

  void _pressionar(String tecla) {
    if (tecla == 'DEL') {
      setState(() {
        _erro = false;
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      });
      return;
    }
    if (_pin.length >= 4) return;
    setState(() {
      _erro = false;
      _pin += tecla;
    });
    if (_pin.length == 4) _verificar();
  }

  Future<void> _verificar() async {
    final ok = await context.read<UsuarioProvider>().verificarPin(_pin);
    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.cuidadorHome);
    } else {
      setState(() {
        _erro = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Área do Cuidador'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text('🔒', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('Acesso restrito', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Digite o PIN de 4 dígitos do cuidador',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final preenchido = i < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _erro
                        ? AppColors.red
                        : preenchido
                            ? AppColors.primary
                            : Colors.transparent,
                    border: Border.all(
                      color: _erro ? AppColors.red : AppColors.primary,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            if (_erro) ...[
              const SizedBox(height: 10),
              Text('PIN incorreto', style: AppTextStyles.body.copyWith(color: AppColors.red)),
            ],
            const SizedBox(height: 32),
            // Numpad
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.8,
              ),
              itemCount: _teclas.length,
              itemBuilder: (_, i) {
                final t = _teclas[i];
                if (t.isEmpty) return const SizedBox.shrink();
                if (t == 'DEL') {
                  return _PinKey(
                    child: const Icon(Icons.backspace_outlined, size: 26, color: AppColors.primary),
                    onTap: () => _pressionar(t),
                  );
                }
                return _PinKey(
                  child: Text(t, style: AppTextStyles.numpadDigit),
                  onTap: () => _pressionar(t),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PinKey({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}
