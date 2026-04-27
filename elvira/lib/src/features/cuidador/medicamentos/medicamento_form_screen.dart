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
  final _dataInicioCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
  final _dataFimCtrl = TextEditingController();
  final _intervaloCtrl = TextEditingController();

  String _unidade = 'comprimido';
  final List<TimeOfDay> _horarios = [];

  Medicamento? _editando;
  bool _salvando = false;

  static const _unidades = ['comprimido', 'cápsula', 'ml', 'UI', 'gota', 'mg', 'g'];

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Medicamento) {
        _editando = args;
        _nomeCtrl.text = args.nome;
        _dosagemCtrl.text = args.dosagem;
        _instrucaoCtrl.text = args.instrucaoUso ?? '';
        _dataInicioCtrl.text = args.dataInicio ?? DateTime.now().toIso8601String().substring(0, 10);
        _dataFimCtrl.text = args.dataFim ?? '';
        _unidade = args.unidade;
        final provider = Provider.of<MedicamentosProvider>(context, listen: false);
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
    _dataInicioCtrl.dispose();
    _dataFimCtrl.dispose();
    _intervaloCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(TextEditingController ctrl) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2040),
    );
    if (d != null) {
      setState(() => ctrl.text = d.toIso8601String().substring(0, 10));
    }
  }

  Future<void> _adicionarHorario() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null && !_horarios.contains(t)) {
      setState(() {
        _horarios.add(t);
        _horarios.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
      });
    }
  }

  void _gerarHorariosAutomaticos() {
    if (_horarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione o horário da primeira dose para o app preencher os demais', style: AppTextStyles.bodySmall)),
      );
      return;
    }
    final int? intervalo = int.tryParse(_intervaloCtrl.text);
    if (intervalo == null || intervalo <= 0 || intervalo > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite um intervalo válido (ex: 8)', style: AppTextStyles.bodySmall)),
      );
      return;
    }

    final primeiraHora = _horarios.first;
    _horarios.clear();

    int h = primeiraHora.hour;
    int m = primeiraHora.minute;

    for (int i = 0; i < (24 / intervalo).floor(); i++) {
      _horarios.add(TimeOfDay(hour: h, minute: m));
      h = (h + intervalo) % 24;
    }

    setState(() {
      _horarios.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
      _intervaloCtrl.clear();
    });
    FocusScope.of(context).unfocus();
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
      dataInicio: _dataInicioCtrl.text.trim().isEmpty ? null : _dataInicioCtrl.text.trim(),
      dataFim: _dataFimCtrl.text.trim().isEmpty ? null : _dataFimCtrl.text.trim(),
    );
    final doses = _horarios.map((h) => DoseMedicamento(
          medicamentoId: _editando?.id ?? 0,
          horario: '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}',
        )).toList();

    try {
      final provider = context.read<MedicamentosProvider>();
      if (_editando != null) {
        await provider.atualizarMedicamento(med, doses);
      } else {
        await provider.adicionarMedicamento(med, doses);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar medicamento: $e')),
        );
        setState(() => _salvando = false);
      }
    }
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
                      isExpanded: true,
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
              
              Text('Duração do Tratamento', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dataInicioCtrl,
                      readOnly: true,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(labelText: 'Início (Obrigatório)'),
                      onTap: () => _selecionarData(_dataInicioCtrl),
                      validator: (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _dataFimCtrl,
                      readOnly: true,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(labelText: 'Fim (Opcional)'),
                      onTap: () => _selecionarData(_dataFimCtrl),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text('Horários', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text('Adicione as horas ou digite um intervalo para calcular automático.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _intervaloCtrl,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        labelText: 'Repetir a cada (horas)',
                        hintText: 'Ex: 8',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _gerarHorariosAutomaticos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(0, 52), // Override global infinity width
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Gerar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                label: Text('Adicionar horário manual', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
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
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label),
      scrollPadding: const EdgeInsets.only(bottom: 80),
      validator: required ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null : null,
    );
  }
}
