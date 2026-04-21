import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/dose_provider.dart';
import '../../../core/providers/medicamentos_provider.dart';
import '../../../core/models/registro_dose.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  List<RegistroDose> _historico = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final h = await context.read<DoseProvider>().getHistorico(7);
    if (mounted) setState(() { _historico = h; _carregando = false; });
  }

  Color _corStatus(StatusDose s) {
    switch (s) {
      case StatusDose.tomado: return AppColors.green;
      case StatusDose.perdido: return AppColors.red;
      case StatusDose.adiado: return AppColors.amber;
      default: return AppColors.accentBlue;
    }
  }

  String _labelStatus(StatusDose s) {
    switch (s) {
      case StatusDose.tomado: return 'tomada';
      case StatusDose.perdido: return 'não registrada';
      case StatusDose.adiado: return 'com atraso';
      default: return 'pendente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final medProvider = context.watch<MedicamentosProvider>();
    final tomadas = _historico.where((r) => r.status == StatusDose.tomado).length;
    final total = _historico.length;
    final taxa = total > 0 ? (tomadas / total * 100).round() : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Relatórios'),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo adesão
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adesão — últimos 7 dias', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text('$taxa%', style: AppTextStyles.clock.copyWith(color: Colors.white, fontSize: 48)),
                              Text('$tomadas de $total doses tomadas', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                        CircularProgressIndicator(
                          value: total > 0 ? tomadas / total : 0,
                          strokeWidth: 8,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation(taxa >= 80 ? AppColors.green : AppColors.amber),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('HISTÓRICO', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  if (_historico.isEmpty)
                    Center(child: Text('Sem dados ainda', style: AppTextStyles.body.copyWith(color: AppColors.textDisabled)))
                  else
                    ..._historico.map((r) {
                      final med = medProvider.getMedicamento(r.doseId);
                      final hora = DateFormat('HH:mm').format(r.dataHoraPrevista);
                      final data = DateFormat('d/M').format(r.dataHoraPrevista);
                      return Padding(
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
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _corStatus(r.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${med?.nome ?? 'Remédio'} $hora ${_labelStatus(r.status)}',
                                  style: AppTextStyles.body,
                                ),
                              ),
                              Text(data, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textDisabled)),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
