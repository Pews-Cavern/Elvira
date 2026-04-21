import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/contatos_provider.dart';
import '../../../core/models/contato.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';

class ContatoFormScreen extends StatefulWidget {
  const ContatoFormScreen({super.key});

  @override
  State<ContatoFormScreen> createState() => _ContatoFormScreenState();
}

class _ContatoFormScreenState extends State<ContatoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  String _relacao = 'familiar';
  bool _ehEmergencia = false;
  Contato? _editando;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editando == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Contato) {
        _editando = args;
        _nomeCtrl.text = args.nome;
        _telefoneCtrl.text = args.telefone;
        _relacao = args.relacao;
        _ehEmergencia = args.ehEmergencia;
      }
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _telefoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    final contato = Contato(
      id: _editando?.id,
      nome: _nomeCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim(),
      relacao: _relacao,
      ehEmergencia: _ehEmergencia,
      ordemExibicao: _editando?.ordemExibicao ?? 0,
    );
    final provider = context.read<ContatosProvider>();
    if (_editando != null) {
      await provider.atualizar(contato);
    } else {
      await provider.adicionar(contato);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ElviraAppBar(title: _editando != null ? 'Editar Contato' : 'Novo Contato'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeCtrl,
                style: AppTextStyles.body,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _telefoneCtrl,
                style: AppTextStyles.body,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone / Celular'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _relacao,
                decoration: const InputDecoration(labelText: 'Tipo de relação'),
                style: AppTextStyles.body,
                items: Contato.relacoes.map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(Contato.relacaoLabel(r)),
                )).toList(),
                onChanged: (v) => setState(() => _relacao = v!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _ehEmergencia,
                onChanged: (v) => setState(() => _ehEmergencia = v),
                title: Text('Contato de emergência', style: AppTextStyles.body),
                subtitle: Text('Aparece na tela de emergência e identidade', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                activeThumbColor: AppColors.red,
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 28),
              ElviraButton(
                label: _editando != null ? 'Salvar alterações' : 'Adicionar contato',
                onPressed: _salvando ? null : _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
