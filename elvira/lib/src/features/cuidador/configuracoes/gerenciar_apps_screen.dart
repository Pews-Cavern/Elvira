import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/usuario_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';

class GerenciarAppsScreen extends StatelessWidget {
  const GerenciarAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Tela Inicial'),
      body: Consumer<UsuarioProvider>(
        builder: (context, provider, child) {
          if (provider.loading || provider.usuario == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final ocultos = provider.usuario!.appsOcultos;

          Widget buildItem(String id, String label, String icon) {
            final isVisible = !ocultos.contains(id);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFDCDCDC)),
              ),
              child: SwitchListTile(
                title: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                value: isVisible,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  provider.alternarAppVisivel(id, val);
                },
              ),
            );
          }

          Widget buildHeader(String title) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                title,
                style: AppTextStyles.h3.copyWith(color: AppColors.primary),
              ),
            );
          }

          Widget buildFixedItem(String label, String icon) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFEFEFEF)),
              ),
              color: const Color(0xFFF9F9F9),
              child: ListTile(
                leading: Text(icon, style: const TextStyle(fontSize: 24)),
                title: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: const Icon(Icons.lock_outline, color: Colors.grey),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Escolha quais aplicativos e funções aparecerão na tela inicial do idoso.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              
              buildHeader('Essencial & Saúde'),
              buildFixedItem('Ligar', '📞'),
              buildItem('remedios', 'Remédios', '💊'),
              buildItem('consultas', 'Consultas', '🩺'),
              buildFixedItem('Avisos', '🔔'),
              buildItem('contatos', 'Contatos', '👥'),
              buildFixedItem('Identidade', '🪪'),

              buildHeader('Aplicativos & Dia a Dia'),
              buildItem('whatsapp', 'WhatsApp', '💬'),
              buildItem('uber', 'Uber', '🚕'),
              buildItem('mapas', 'Mapas', '📍'),
              buildItem('camera', 'Câmera', '📷'),
              buildItem('voz', 'Pesquisa por Voz', '🎤'),

              buildHeader('Entretenimento & Informação'),
              buildItem('youtube', 'YouTube', '▶️'),
              buildItem('radio', 'Rádio', '📻'),
              buildItem('noticias', 'Notícias', '📰'),

              buildHeader('Outros'),
              buildItem('sobre', 'Sobre', 'ℹ️'),
              buildFixedItem('Cuidador', '⚙️'),
            ],
          );
        },
      ),
    );
  }
}
