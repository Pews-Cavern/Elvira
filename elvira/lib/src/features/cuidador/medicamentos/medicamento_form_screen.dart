import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/medicamentos_provider.dart';
import '../../../core/models/medicamento.dart';
import '../../../core/models/dose_medicamento.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';

class MedicamentoFormScreen extends StatefulWidget {
  const MedicamentoFormScreen({super.key});

  @override
  State<MedicamentoFormScreen> createState() => _MedicamentoFormScreenState();
}

class _MedicamentoFormScreenState extends State<MedicamentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _dosagemCtrl = TextEditingController();
  final _instrucaoCtrl = TextEditingController();
  String _unidade = 'comprimido';
  final List<TimeOfDay> _horarios = [];

  Medicamento? _editando;
  bool _salvando = false;

  static const _unidades = ['comprimido', 'cápsula', 'ml', 'UI', 'gota', 'mg', 'g'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editando == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Medicamento) {
        _editando = args;
        _nomeCtrl.text = args.nome;
        _dosagemCtrl.text = args.dosagem;
        _instrucaoCtrl.text = args.instrucaoUso ?? '';
        _unidade = args.unidade;
        final provider = context.read<MedicamentosProvider>();
        final doses = provider.dosesDoMedicamento(args.id!);
        for (final d in doses) {
          final partes = d.horario.split(':');
          _horarios.add(TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1])));
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _dosagemCtrl.dispose();
    _instrucaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _adicionarHorario() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _horarios.add(t));
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_horarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione ao menos 1 horário', style: AppTextStyles.body)),
      );
      return;
    }
    setState(() => _salvando = true);
    final med = Medicamento(
      id: _editando?.id,
      nome: _nomeCtrl.text.trim(),
      dosagem: _dosagemCtrl.text.trim(),
      unidade: _unidade,
      instrucaoUso: _instrucaoCtrl.text.trim().isEmpty ? null : _instrucaoCtrl.text.trim(),
    );
    final doses = _horarios.map((h) => DoseMedicamento(
          medicamentoId: _editando?.id ?? 0,
          horario: '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}',
        )).toList();

    final provider = context.read<MedicamentosProvider>();
    if (_editando != null) {
      await provider.atualizarMedicamento(med, doses);
    } else {
      await provider.adicionarMedicamento(med, doses);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ElviraAppBar(title: _editando != null ? 'Editar Medicamento' : 'Novo Medicamento'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campo('Nome do medicamento', _nomeCtrl, required: true),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _campo('Dosagem', _dosagemCtrl, required: true, keyboardType: TextInputType.text)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _unidade,
                      decoration: const InputDecoration(labelText: 'Unidade'),
                      style: AppTextStyles.body,
                      items: _unidades.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) => setState(() => _unidade = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _campo('Instrução de uso (opcional)', _instrucaoCtrl, maxLines: 2),
              const SizedBox(height: 24),
              Text('Horários', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              ..._horarios.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.blueLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            '${e.value.hour.toString().padLeft(2, '0')}:${e.value.minute.toString().padLeft(2, '0')}',
                            style: AppTextStyles.medicTime,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.red),
                            onPressed: () => setState(() => _horarios.removeAt(e.key)),
                          ),
                        ],
                      ),
                    ),
                  )),
              OutlinedButton.icon(
                onPressed: _adicionarHorario,
                icon: const Icon(Icons.add),
                label: Text('Adicionar horário', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElviraButton(
                label: _editando != null ? 'Salvar alterações' : 'Adicionar medicamento',
                onPressed: _salvando ? null : _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {bool required = false, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      style: AppTextStyles.body,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: required ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null : null,
    );
  }
}
