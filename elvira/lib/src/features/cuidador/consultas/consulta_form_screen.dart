import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/consulta_medica.dart';
import '../../../core/providers/consultas_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';

class ConsultaFormScreen extends StatefulWidget {
  const ConsultaFormScreen({super.key});

  @override
  State<ConsultaFormScreen> createState() => _ConsultaFormScreenState();
}

class _ConsultaFormScreenState extends State<ConsultaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hospitalCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _mapsCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();

  DateTime? _dateTime;
  int _lembreteMinutos = 60;
  ConsultaMedica? _editando;
  bool _salvando = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) return;
    _isInit = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ConsultaMedica) {
      _editando = args;
      _hospitalCtrl.text = args.hospitalName;
      _notesCtrl.text = args.notes ?? '';
      _mapsCtrl.text = args.mapsUrl ?? '';
      _dateTime = args.dateTime;
      _lembreteMinutos = args.lembreteMinutos;
      _dateCtrl.text = _formatDate(args.dateTime);
      _timeCtrl.text = _formatTime(args.dateTime);
    }
  }

  @override
  void dispose() {
    _hospitalCtrl.dispose();
    _notesCtrl.dispose();
    _mapsCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final initialDate = _dateTime ?? DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2040),
    );
    if (d != null) {
      _dateTime = DateTime(
        d.year,
        d.month,
        d.day,
        _dateTime?.hour ?? TimeOfDay.now().hour,
        _dateTime?.minute ?? TimeOfDay.now().minute,
      );
      setState(() {
        _dateCtrl.text = _formatDate(_dateTime!);
      });
    }
  }

  Future<void> _selecionarHora() async {
    final t = await showTimePicker(
      context: context,
      initialTime:
          _dateTime != null
              ? TimeOfDay(hour: _dateTime!.hour, minute: _dateTime!.minute)
              : TimeOfDay.now(),
    );
    if (t != null) {
      final base = _dateTime ?? DateTime.now();
      _dateTime = DateTime(base.year, base.month, base.day, t.hour, t.minute);
      setState(() {
        _timeCtrl.text = _formatTime(_dateTime!);
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data e o horário da consulta.'),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final consulta = ConsultaMedica(
      id: _editando?.id,
      hospitalName: _hospitalCtrl.text.trim(),
      dateTime: _dateTime!,
      mapsUrl: _mapsCtrl.text.trim().isEmpty ? null : _mapsCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      lembreteMinutos: _lembreteMinutos,
    );

    try {
      final provider = context.read<ConsultasProvider>();
      if (_editando != null) {
        await provider.atualizarConsulta(consulta);
      } else {
        await provider.adicionarConsulta(consulta);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar consulta: $e')));
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ElviraAppBar(
        title: _editando != null ? 'Editar Consulta' : 'Nova Consulta',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campo('Hospital / Clínica', _hospitalCtrl, required: true),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateCtrl,
                      readOnly: true,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        labelText: 'Data da consulta',
                      ),
                      onTap: _selecionarData,
                      validator:
                          (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _timeCtrl,
                      readOnly: true,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(labelText: 'Horário'),
                      onTap: _selecionarHora,
                      validator:
                          (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                value: _lembreteMinutos,
                decoration: const InputDecoration(
                  labelText: 'Avisar com antecedência',
                ),
                style: AppTextStyles.body,
                items: const [
                  DropdownMenuItem(value: 60, child: Text('1 hora antes')),
                  DropdownMenuItem(value: 120, child: Text('2 horas antes')),
                ],
                onChanged:
                    (value) => setState(() => _lembreteMinutos = value ?? 60),
              ),
              const SizedBox(height: 14),
              _campo('Link do Maps / GPS (opcional)', _mapsCtrl),
              const SizedBox(height: 14),
              _campo('Observações (opcional)', _notesCtrl, maxLines: 4),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blueXLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.blueLight),
                ),
                child: Text(
                  'O aviso será programado automaticamente com antecedência para ajudar no preparo.',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              ElviraButton(
                label:
                    _editando != null
                        ? 'Salvar alterações'
                        : 'Adicionar consulta',
                onPressed: _salvando ? null : _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(
    String label,
    TextEditingController ctrl, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      style: AppTextStyles.body,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label),
      validator:
          required
              ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null
              : null,
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
