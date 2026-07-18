import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/status_bar_widget.dart';
import '../../core/routes/app_routes.dart';
import '../../core/providers/usuario_provider.dart';

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
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
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
                      final escala = context.watch<UsuarioProvider>().escalaFonte;
                      final tileWidth = (constraints.maxWidth - spacing) / 2;
                      final tileHeight = tileWidth * (0.88 + ((escala - 1.0) * 0.4));

                      final ocultos = context.watch<UsuarioProvider>().usuario?.appsOcultos ?? [];

                      Widget buildGrid(List<Widget> tiles) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: tileWidth / tileHeight,
                          children: tiles,
                        );
                      }

                      Widget buildSectionTitle(String title) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 24, left: 4),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0C447C),
                            ),
                          ),
                        );
                      }

                      final saudeTiles = <Widget>[
                        const _AppTile(emoji: '📞', label: 'Ligar', route: AppRoutes.discagem, color: Color(0xFFDCEEFB)),
                        if (!ocultos.contains('remedios')) const _AppTile(emoji: '💊', label: 'Remédios', route: AppRoutes.remedios, color: Color(0xFFD9F4EA)),
                        if (!ocultos.contains('consultas')) const _AppTile(emoji: '🩺', label: 'Consultas', route: AppRoutes.consultas, color: Color(0xFFE8F2FF)),
                        const _AppTile(emoji: '🔔', label: 'Avisos', route: AppRoutes.notificacoes, color: Color(0xFFF0E5F8)),
                        if (!ocultos.contains('contatos')) const _AppTile(emoji: '👥', label: 'Contatos', route: AppRoutes.contatos, color: Color(0xFFDCEEFB)),
                        const _AppTile(emoji: '🪪', label: 'Identidade', route: AppRoutes.identidade, color: Color(0xFFFFF0CC)),
                      ];

                      final diaDiaTiles = <Widget>[
                        if (!ocultos.contains('whatsapp')) _AppTile(
                          emoji: '',
                          label: 'WhatsApp',
                          color: const Color(0xFFDCF8C6),
                          customIcon: const FaIcon(FontAwesomeIcons.whatsapp, size: 44, color: Color(0xFF25D366)),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.intent.action.MAIN', package: 'com.whatsapp', componentName: 'com.whatsapp.Main');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.whatsapp'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                        if (!ocultos.contains('uber')) _AppTile(
                          emoji: '',
                          label: 'Uber',
                          color: const Color(0xFFE5E5E5),
                          customIcon: const FaIcon(FontAwesomeIcons.uber, size: 44, color: Colors.black),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.intent.action.MAIN', package: 'com.ubercab');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://m.uber.com/'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                        if (!ocultos.contains('mapas')) _AppTile(
                          emoji: '',
                          label: 'Mapas',
                          color: const Color(0xFFFFEBE5),
                          customIcon: const Icon(Icons.location_on_rounded, size: 44, color: Color(0xFFEA4335)),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'action_view', data: 'geo:0,0?q=', package: 'com.google.android.apps.maps');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://maps.google.com/'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                        if (!ocultos.contains('camera')) const _AppTile(emoji: '📷', label: 'Câmera', route: AppRoutes.camera, color: Color(0xFFFFE5CC)),
                        if (!ocultos.contains('voz')) _AppTile(
                          emoji: '',
                          label: 'Pesquisa por Voz',
                          color: const Color(0xFFF0E5F8),
                          customIcon: const Icon(Icons.mic_rounded, size: 44, color: Color(0xFF9C27B0)),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.speech.action.WEB_SEARCH', package: 'com.google.android.googlequicksearchbox');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://www.google.com'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                      ];

                      final infoTiles = <Widget>[
                        if (!ocultos.contains('youtube')) _AppTile(
                          emoji: '',
                          label: 'YouTube',
                          color: const Color(0xFFFFE5E5),
                          customIcon: const FaIcon(FontAwesomeIcons.youtube, size: 44, color: Color(0xFFFF0000)),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.intent.action.MAIN', package: 'com.google.android.youtube');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://www.youtube.com/'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                        if (!ocultos.contains('radio')) _AppTile(
                          emoji: '📻',
                          label: 'Rádio',
                          color: const Color(0xFFFFF4D9),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.intent.action.MAIN', package: 'tunein.player');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://tunein.com/'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                        if (!ocultos.contains('noticias')) _AppTile(
                          emoji: '📰',
                          label: 'Notícias',
                          color: const Color(0xFFE8F2FF),
                          onTap: () async {
                            const intent = AndroidIntent(action: 'android.intent.action.MAIN', package: 'com.google.android.apps.magazines');
                            try { await intent.launch(); } catch (_) { await launchUrl(Uri.parse('https://g1.globo.com/'), mode: LaunchMode.externalApplication); }
                          },
                        ),
                      ];

                      final outrosTiles = <Widget>[
                        if (!ocultos.contains('sobre')) const _AppTile(emoji: 'ℹ️', label: 'Sobre', route: AppRoutes.sobre, color: Color(0xFFE5F4F0)),
                        _AppTile(
                          emoji: '⚙️',
                          label: 'Cuidador',
                          color: const Color(0xFFDCEEFB),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final temCuidador = context.read<UsuarioProvider>().temCuidador;
                            Navigator.pushNamed(
                              context,
                              temCuidador ? AppRoutes.cuidadorPin : AppRoutes.cuidadorHome,
                            );
                          },
                        ),
                      ];

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 20, top: 0),
                        children: [
                          if (saudeTiles.isNotEmpty) ...[
                            buildSectionTitle('Essencial & Saúde'),
                            buildGrid(saudeTiles),
                          ],
                          if (diaDiaTiles.isNotEmpty) ...[
                            buildSectionTitle('Aplicativos & Dia a Dia'),
                            buildGrid(diaDiaTiles),
                          ],
                          if (infoTiles.isNotEmpty) ...[
                            buildSectionTitle('Entretenimento & Informação'),
                            buildGrid(infoTiles),
                          ],
                          if (outrosTiles.isNotEmpty) ...[
                            buildSectionTitle('Outros'),
                            buildGrid(outrosTiles),
                          ],
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
                    label: Text(
                      'EMERGÊNCIA',
                      style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
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
          onTap:
              onTap ??
              (route != null
                  ? () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, route!);
                  }
                  : null),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (customIcon != null)
                  customIcon!
                else
                  Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTextStyles.appLabel.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
