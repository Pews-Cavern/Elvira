import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/status_bar_widget.dart';
import '../../core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Status (hora, data, bateria)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const StatusBarWidget(),
                ),
                const SizedBox(height: 16),
                // Grade de apps
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: const [
                      _AppTile(emoji: '📞', label: 'Ligar', route: AppRoutes.discagem, color: Color(0xFFE6F1FB)),
                      _AppTile(emoji: '💊', label: 'Remédios', route: AppRoutes.remedios, color: Color(0xFFE8F8F2)),
                      _AppTile(emoji: '👥', label: 'Contatos', route: AppRoutes.contatos, color: Color(0xFFE6F1FB)),
                      _AppTile(emoji: '🪪', label: 'Identidade', route: AppRoutes.identidade, color: Color(0xFFFFF3E0)),
                      _AppTile(emoji: '🔔', label: 'Avisos', route: AppRoutes.notificacoes, color: Color(0xFFF3E5F5)),
                      _AppTile(emoji: '⚙️', label: 'Cuidador', route: AppRoutes.cuidadorPin, color: Color(0xFFE6F1FB)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Botão de emergência
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.emergencia),
                    icon: const Icon(Icons.warning_amber_rounded, size: 32),
                    label: Text('EMERGÊNCIA', style: AppTextStyles.buttonLarge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String route;
  final Color color;

  const _AppTile({
    required this.emoji,
    required this.label,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.appLabel.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
