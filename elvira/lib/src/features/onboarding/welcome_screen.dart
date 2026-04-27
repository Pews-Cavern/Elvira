import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _pedirPermissoesEVamosComecar(BuildContext context) async {
    final aceitou = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Permissões Necessárias',
          style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Para que a Elvira funcione corretamente (como o botão SOS e os alarmes de remédios), precisamos de permissões para fazer ligações, enviar SMS, acessar contatos e enviar notificações.',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text('Entendi', style: AppTextStyles.button),
          ),
        ],
      ),
    );

    if (aceitou == true) {
      await [
        Permission.sms,
        Permission.phone,
        Permission.contacts,
        Permission.notification,
      ].request();
      
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.step1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 48),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.28),
                    child: Image.asset(
                      'assets/icons/Elvira_Neson.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Olá! Eu sou a Elvira.',
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Feito com carinho para ajudar você a usar o celular com mais facilidade, segurança e autonomia.',
                    style: AppTextStyles.body.copyWith(color: Colors.white.withAlpha(220), fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 72,
                    child: ElevatedButton(
                      onPressed: () => _pedirPermissoesEVamosComecar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                      ),
                      child: Text('Vamos começar!', style: AppTextStyles.buttonLarge),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(
                        'Já tenho conta — entrar',
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
