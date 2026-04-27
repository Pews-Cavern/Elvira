import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/usuario_provider.dart';
import '../../../core/models/usuario.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';

class IdentidadeFormScreen extends StatefulWidget {
  const IdentidadeFormScreen({super.key});

  @override
  State<IdentidadeFormScreen> createState() => _IdentidadeFormScreenState();
}

class _IdentidadeFormScreenState extends State<IdentidadeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _dataNascCtrl = TextEditingController();
  final _tipoSangCtrl = TextEditingController();
  final _planoSaudeCtrl = TextEditingController();
  
  List<String> _alergias = [];
  List<String> _condicoes = [];

  bool _salvando = false;

  static const _tiposSanguineos = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final u = context.read<UsuarioProvider>().usuario;
      if (u != null) {
        _nomeCtrl.text = u.nome;
        _dataNascCtrl.text = u.dataNascimento ?? '';
        _tipoSangCtrl.text = u.tipoSanguineo ?? '';
        _planoSaudeCtrl.text = u.planoSaude ?? '';
        
        if (u.alergias != null && u.alergias!.isNotEmpty) {
          _alergias = u.alergias!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
        if (u.condicoesSaude != null && u.condicoesSaude!.isNotEmpty) {
          _condicoes = u.condicoesSaude!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _dataNascCtrl.dispose();
    _tipoSangCtrl.dispose();
    _planoSaudeCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    final provider = context.read<UsuarioProvider>();
    final atual = provider.usuario;
    final novo = Usuario(
      id: atual?.id,
      nome: _nomeCtrl.text.trim(),
      genero: atual?.genero ?? 'nao_informado',
      dataNascimento: _dataNascCtrl.text.trim().isEmpty ? null : _dataNascCtrl.text.trim(),
      tipoSanguineo: _tipoSangCtrl.text.trim().isEmpty ? null : _tipoSangCtrl.text.trim(),
      planoSaude: _planoSaudeCtrl.text.trim().isEmpty ? null : _planoSaudeCtrl.text.trim(),
      alergias: _alergias.isEmpty ? null : _alergias.join(','),
      condicoesSaude: _condicoes.isEmpty ? null : _condicoes.join(','),
      pinCuidador: atual?.pinCuidador,
      tamanhoFonteBase: atual?.tamanhoFonteBase ?? 1.0,
      onboardingCompleto: atual?.onboardingCompleto ?? true,
    );
    await provider.salvar(novo);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _selecionarData() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(1950),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => _dataNascCtrl.text = d.toIso8601String().substring(0, 10));
    }
  }

  Future<void> _adicionarItemLista(String titulo, List<String> lista) async {
    final ctrl = TextEditingController();
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Adicionar $titulo', style: AppTextStyles.h3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: 'Digite aqui...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );

    if (res != null && res.isNotEmpty && !lista.contains(res)) {
      setState(() => lista.add(res));
    }
  }

  Widget _buildChipsList(String titulo, List<String> lista) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: AppTextStyles.bodyBold.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...lista.map((item) => Chip(
                  label: Text(item, style: AppTextStyles.bodySmall),
                  backgroundColor: AppColors.blueLight,
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => setState(() => lista.remove(item)),
                )),
            ActionChip(
              label: const Text('+ Adicionar'),
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.primary),
              labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
              onPressed: () => _adicionarItemLista(titulo, lista),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Dados Pessoais e Médicos'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Identidade', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              _campo('Nome completo', _nomeCtrl, required: true),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dataNascCtrl,
                readOnly: true,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento',
                  suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                ),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 24),
              Text('Informações Médicas', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _tipoSangCtrl.text.isEmpty ? null : _tipoSangCtrl.text,
                decoration: const InputDecoration(labelText: 'Tipo sanguíneo'),
                style: AppTextStyles.body,
                items: _tiposSanguineos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _tipoSangCtrl.text = v ?? ''),
              ),
              const SizedBox(height: 14),
              _campo('Plano de Saúde', _planoSaudeCtrl, hint: 'Ex: Unimed, SulAmérica'),
              const SizedBox(height: 20),
              _buildChipsList('Alergias', _alergias),
              _buildChipsList('Condições de saúde', _condicoes),
              const SizedBox(height: 28),
              ElviraButton(label: 'Salvar dados', onPressed: _salvando ? null : _salvar),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {bool required = false, String? hint}) {
    return TextFormField(
      controller: ctrl,
      style: AppTextStyles.body,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label, hintText: hint),
      scrollPadding: const EdgeInsets.only(bottom: 80),
      validator: required ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null : null,
    );
  }
}
