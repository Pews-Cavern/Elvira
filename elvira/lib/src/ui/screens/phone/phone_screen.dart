import 'package:elvira/src/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: elviraColorMap[ElviraColor.background],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 36),
                    color: elviraColorMap[ElviraColor.primary],
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Telefone',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: elviraColorMap[ElviraColor.onBackground],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildPhoneAction(
                      icon: Icons.dialpad,
                      label: 'Digitar Número',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.dialPad);
                      },
                    ),
                    _buildPhoneAction(
                      icon: Icons.contact_phone,
                      label: 'Contatos Favoritos',
                      onTap: () {
                        // Navega pra tela de contatos
                      },
                    ),
                    _buildPhoneAction(
                      icon: Icons.history,
                      label: 'Chamadas Recentes',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.callHistory);
                      },
                    ),
                    _buildPhoneAction(
                      icon: Icons.settings_phone,
                      label: 'Configurar Contatos',
                      onTap: () {
                        // Tela de config de chamadas
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: elviraColorMap[ElviraColor.primary]),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
