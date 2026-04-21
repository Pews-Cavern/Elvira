import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/providers/dose_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';

class CuidadorHomeScreen extends StatelessWidget {
  const CuidadorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Área do Cuidador'),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Consumer2<UsuarioProvider, DoseProvider>(
        builder: (_, usuProvider, doseProvider, _) {
          final usuario = usuProvider.usuario;
          final dataHoje = DateFormat("d 'de' MMMM yyyy", 'pt_BR').format(DateTime.now());
          final perdidas = doseProvider.perdidas;
          final tomadas = doseProvider.registrosHoje.where((r) => r.status.name == 'tomado').length;
          final total = doseProvider.registrosHoje.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header paciente
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.blueLight,
                        child: Text(
                          usuario?.nome.substring(0, 2).toUpperCase() ?? 'EL',
                          style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(usuario?.nome ?? 'Usuário', style: AppTextStyles.h3.copyWith(color: Colors.white)),
                          Text(dataHoje, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Alertas
                if (perdidas.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.redLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.redMedium),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.amber, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dose perdida hoje', style: AppTextStyles.bodyBold.copyWith(color: AppColors.red)),
                              Text('${perdidas.length} dose(s) não registrada(s)', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                          child: Text('${perdidas.length} alerta', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Resumo
                Text('RESUMO DE HOJE', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ResumoCard(valor: '$tomadas / $total', label: 'Remédios tomados', color: AppColors.green),
                    const SizedBox(width: 10),
                    _ResumoCard(valor: '${perdidas.length}', label: 'Dose${perdidas.length == 1 ? '' : 's'} perdida${perdidas.length == 1 ? '' : 's'}', color: AppColors.red),
                  ],
                ),
                const SizedBox(height: 20),
                // Grid de gerenciamento
                Text('CONFIGURAR', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                  children: const [
                    _GridBtn(emoji: '💊', titulo: 'Medicamentos', sub: 'Doses, horários e remédios', route: AppRoutes.cuidadorMedicamentos),
                    _GridBtn(emoji: '👥', titulo: 'Contatos', sub: 'Família, médicos, emergência', route: AppRoutes.cuidadorContatos),
                    _GridBtn(emoji: '🪪', titulo: 'Identidade', sub: 'Dados, sangue, alergias', route: AppRoutes.cuidadorIdentidade),
                    _GridBtn(emoji: '📊', titulo: 'Relatórios', sub: 'Histórico de doses e uso', route: AppRoutes.cuidadorRelatorios),
                    _GridBtn(emoji: '⚙️', titulo: 'Configurações', sub: 'PIN, fonte, acessibilidade', route: AppRoutes.cuidadorConfiguracoes),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                    icon: const Icon(Icons.lock_outline),
                    label: Text('Sair da área do cuidador', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.blueLight, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;
  const _ResumoCard({required this.valor, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.blueLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valor, style: AppTextStyles.h2.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _GridBtn extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String sub;
  final String route;
  const _GridBtn({required this.emoji, required this.titulo, required this.sub, required this.route});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(titulo, style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary)),
              Text(sub, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}
