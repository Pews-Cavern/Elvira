import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/usuario_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';
import '../../../services/call_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _pinAtualCtrl = TextEditingController();
  final _pinNovoCtrl = TextEditingController();
  final _pinConfCtrl = TextEditingController();
  double _escala = 1.0;
  bool? _isDefaultDialer;

  @override
  void initState() {
    super.initState();
    _escala = context.read<UsuarioProvider>().escalaFonte;
    _checkDefaultDialer();
  }

  Future<void> _checkDefaultDialer() async {
    final v = await CallService.instance.isDefaultDialer();
    if (mounted) setState(() => _isDefaultDialer = v);
  }

  @override
  void dispose() {
    _pinAtualCtrl.dispose();
    _pinNovoCtrl.dispose();
    _pinConfCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvarEscala() async {
    await context.read<UsuarioProvider>().atualizarEscalaFonte(_escala);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tamanho do texto salvo!', style: AppTextStyles.body)),
      );
    }
  }

  Future<void> _trocarPin() async {
    final provider = context.read<UsuarioProvider>();
    final ok = await provider.verificarPin(_pinAtualCtrl.text);
    if (!ok) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN atual incorreto', style: AppTextStyles.body)));
      return;
    }
    if (_pinNovoCtrl.text != _pinConfCtrl.text || _pinNovoCtrl.text.length != 4) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PINs não conferem', style: AppTextStyles.body)));
      return;
    }
    await provider.definirPin(_pinNovoCtrl.text);
    _pinAtualCtrl.clear();
    _pinNovoCtrl.clear();
    _pinConfCtrl.clear();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN alterado com sucesso!', style: AppTextStyles.body)));
  }

  @override
  Widget build(BuildContext context) {
    final escalas = [1.0, 1.15, 1.3, 1.5, 1.7];
    final nomes = ['Normal', 'Grande', 'Muito grande', 'Extra grande', 'Máximo'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Configurações'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Tela de chamada ──────────────────────────────
            Text('Tela de chamada', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDefaultDialer == true
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                    color: _isDefaultDialer == true
                        ? AppColors.green
                        : AppColors.amber,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isDefaultDialer == true
                          ? 'Tela simplificada ativa. O Elvira mostra só Viva-voz e Encerrar durante as ligações.'
                          : 'Para usar a tela simplificada de chamadas, defina o Elvira como app de telefone padrão.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            if (_isDefaultDialer == false) ...[
              const SizedBox(height: 12),
              ElviraButton(
                label: 'Definir como telefone padrão',
                onPressed: () async {
                  await CallService.instance.requestDefaultDialer();
                  await Future.delayed(const Duration(milliseconds: 800));
                  await _checkDefaultDialer();
                },
              ),
            ],
            const SizedBox(height: 28),
            // Tamanho de fonte
            Text('Tamanho do texto', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.blueLight)),
              child: Column(
                children: [
                  Text(
                    'Texto de exemplo',
                    style: TextStyle(fontSize: 18 * _escala, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    textScaler: TextScaler.noScaling,
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: escalas.indexOf(_escala).toDouble(),
                    min: 0,
                    max: (escalas.length - 1).toDouble(),
                    divisions: escalas.length - 1,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _escala = escalas[v.round()]),
                  ),
                  Text(nomes[escalas.indexOf(_escala)], style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElviraButton(label: 'Aplicar tamanho', onPressed: _salvarEscala),
            const SizedBox(height: 28),
            // Trocar PIN
            Text('Trocar PIN do cuidador', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.blueLight)),
              child: Column(
                children: [
                  _pinField('PIN atual', _pinAtualCtrl),
                  const SizedBox(height: 10),
                  _pinField('Novo PIN (4 dígitos)', _pinNovoCtrl),
                  const SizedBox(height: 10),
                  _pinField('Confirmar novo PIN', _pinConfCtrl),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElviraButton(label: 'Trocar PIN', onPressed: _trocarPin),
          ],
        ),
      ),
    );
  }

  Widget _pinField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      maxLength: 4,
      obscureText: true,
      style: AppTextStyles.body,
      decoration: InputDecoration(labelText: label, counterText: ''),
    );
  }
}
