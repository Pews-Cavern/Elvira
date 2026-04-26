import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/models/usuario.dart';
import '../../core/routes/app_routes.dart';
import 'onboarding_scaffold.dart';

class Step1NameScreen extends StatefulWidget {
  const Step1NameScreen({super.key});

  @override
  State<Step1NameScreen> createState() => _Step1NameScreenState();
}

class _Step1NameScreenState extends State<Step1NameScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    final nome = _controller.text.trim();
    if (nome.isEmpty) return;
    final provider = context.read<UsuarioProvider>();
    final atual = provider.usuario;
    await provider.salvar(
      atual != null ? atual.copyWith(nome: nome) : Usuario(nome: nome),
    );
    if (mounted) Navigator.pushNamed(context, AppRoutes.step2);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      totalSteps: 4,
      emoji: '👋',
      titulo: 'Qual é o seu nome?',
      subtitulo: 'Como podemos te chamar?',
      onContinuar: _continuar,
      onVoltar: () => Navigator.pop(context),
      continuarHabilitado: true,
      content: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (_, _, _) => TextField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(hintText: 'Seu nome aqui'),
          scrollPadding: const EdgeInsets.only(bottom: 150),
          onSubmitted: (_) => _continuar(),
        ),
      ),
    );
  }
}
