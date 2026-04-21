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
  final _alergiasCtrl = TextEditingController();
  final _condicoesCtrl = TextEditingController();
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
        _alergiasCtrl.text = u.alergias ?? '';
        _condicoesCtrl.text = u.condicoesSaude ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _dataNascCtrl.dispose();
    _tipoSangCtrl.dispose();
    _alergiasCtrl.dispose();
    _condicoesCtrl.dispose();
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
      alergias: _alergiasCtrl.text.trim().isEmpty ? null : _alergiasCtrl.text.trim(),
      condicoesSaude: _condicoesCtrl.text.trim().isEmpty ? null : _condicoesCtrl.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Dados Pessoais'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _tipoSangCtrl.text.isEmpty ? null : _tipoSangCtrl.text,
                decoration: const InputDecoration(labelText: 'Tipo sanguíneo'),
                style: AppTextStyles.body,
                items: _tiposSanguineos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _tipoSangCtrl.text = v ?? ''),
              ),
              const SizedBox(height: 14),
              _campo('Alergias', _alergiasCtrl, hint: 'Ex: Penicilina, Dipirona'),
              const SizedBox(height: 14),
              _campo('Condições de saúde', _condicoesCtrl, maxLines: 3, hint: 'Ex: Hipertensão, Diabetes tipo 2'),
              const SizedBox(height: 28),
              ElviraButton(label: 'Salvar dados', onPressed: _salvando ? null : _salvar),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {bool required = false, int maxLines = 1, String? hint}) {
    return TextFormField(
      controller: ctrl,
      style: AppTextStyles.body,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: required ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null : null,
    );
  }
}
