import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import 'onboarding_scaffold.dart';

class Step2GenderScreen extends StatefulWidget {
  const Step2GenderScreen({super.key});

  @override
  State<Step2GenderScreen> createState() => _Step2GenderScreenState();
}

class _Step2GenderScreenState extends State<Step2GenderScreen> {
  String? _selected;

  final _opcoes = const [
    {'valor': 'feminino', 'imagem': 'assets/images/personagens/elvira/Elvira_Portrait.png', 'titulo': 'Avó / Senhora', 'sub': 'Feminino'},
    {'valor': 'masculino', 'imagem': 'assets/images/personagens/nelson/Nelson_Portrait.png', 'titulo': 'Avô / Senhor', 'sub': 'Masculino'},
    {'valor': 'nao_informado', 'imagem': '', 'titulo': 'Prefiro não dizer', 'sub': ''},
  ];

  Future<void> _continuar() async {
    if (_selected == null) return;
    final provider = context.read<UsuarioProvider>();
    await provider.salvar(provider.usuario!.copyWith(genero: _selected));
    if (mounted) Navigator.pushNamed(context, AppRoutes.step3);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 2,
      totalSteps: 4,
      emoji: '🙋',
      titulo: 'Como prefere ser chamado?',
      onContinuar: _continuar,
      onVoltar: () => Navigator.pop(context),
      continuarHabilitado: _selected != null,
      content: Column(
        children: _opcoes.map((op) {
          final selecionado = _selected == op['valor'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selected = op['valor'] as String),
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
                    (op['imagem'] as String).isNotEmpty
                        ? Image.asset(op['imagem'] as String, width: 48, height: 48, fit: BoxFit.contain)
                        : const Text('🙂', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(op['titulo'] as String, style: AppTextStyles.bodyBold),
                        if ((op['sub'] as String).isNotEmpty)
                          Text(op['sub'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
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
