import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const StatusBarWidget(),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 12.0;
                      final tileWidth = (constraints.maxWidth - spacing) / 2;
                      final tileHeight = tileWidth * 0.88;
                      return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: tileWidth / tileHeight,
                        children: [
                          const _AppTile(emoji: '📞', label: 'Ligar', route: AppRoutes.discagem, color: Color(0xFFDCEEFB)),
                          const _AppTile(emoji: '💊', label: 'Remédios', route: AppRoutes.remedios, color: Color(0xFFD9F4EA)),
                          const _AppTile(emoji: '👥', label: 'Contatos', route: AppRoutes.contatos, color: Color(0xFFDCEEFB)),
                          const _AppTile(emoji: '🪪', label: 'Identidade', route: AppRoutes.identidade, color: Color(0xFFFFF0CC)),
                          const _AppTile(emoji: '🔔', label: 'Avisos', route: AppRoutes.notificacoes, color: Color(0xFFF0E5F8)),
                          const _AppTile(emoji: '📷', label: 'Câmera', route: AppRoutes.camera, color: Color(0xFFFFE5CC)),
                          const _AppTile(emoji: 'ℹ️', label: 'Sobre', route: AppRoutes.sobre, color: Color(0xFFE5F4F0)),
                          const _AppTile(emoji: '⚙️', label: 'Cuidador', route: AppRoutes.cuidadorPin, color: Color(0xFFDCEEFB)),
                          _AppTile(
                            emoji: '',
                            label: 'WhatsApp',
                            color: const Color(0xFFDCF8C6),
                            customIcon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              size: 52,
                              color: Color(0xFF25D366),
                            ),
                            onTap: () async {
                              const intent = AndroidIntent(
                                action: 'android.intent.action.MAIN',
                                package: 'com.whatsapp',
                                componentName: 'com.whatsapp.Main',
                              );
                              try {
                                await intent.launch();
                              } catch (_) {
                                // WhatsApp não instalado → abre Play Store
                                await launchUrl(
                                  Uri.parse('https://play.google.com/store/apps/details?id=com.whatsapp'),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                          _AppTile(
                            emoji: '',
                            label: 'Pesquisa por Voz',
                            color: const Color(0xFFF0E5F8),
                            customIcon: const Icon(Icons.mic_rounded, size: 52, color: Color(0xFF9C27B0)),
                            onTap: () async {
                              // Dispara o Google Voice Search diretamente (Ok Google)
                              const intent = AndroidIntent(
                                action: 'android.speech.action.WEB_SEARCH',
                                package: 'com.google.android.googlequicksearchbox',
                              );
                              try {
                                await intent.launch();
                              } catch (_) {
                                // Fallback: abre o Google no navegador
                                await launchUrl(
                                  Uri.parse('https://www.google.com'),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 76,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.pushNamed(context, AppRoutes.emergencia);
                    },
                    icon: const Icon(Icons.warning_amber_rounded, size: 34),
                    label: Text('EMERGÊNCIA', style: AppTextStyles.buttonLarge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 4,
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
  final String? route;
  final Color color;
  final VoidCallback? onTap;
  final Widget? customIcon;

  const _AppTile({
    required this.emoji,
    required this.label,
    this.route,
    required this.color,
    this.onTap,
    this.customIcon,
  });

  // Escurece a cor do fundo para usar como borda
  Color _bordaEscura() {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _bordaEscura(), width: 2.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap ??
              (route != null
                  ? () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, route!);
                    }
                  : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (customIcon != null)
              customIcon!
            else
              Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyles.appLabel.copyWith(color: AppColors.primary)),
          ],
        ),
        ),
      ),
    );
  }
}
