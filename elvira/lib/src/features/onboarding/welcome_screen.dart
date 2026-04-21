import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text('👴🏼👵🏼', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 40),
              Text(
                'Olá! Eu sou a Elvira.',
                style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Feito com carinho para ajudar você a usar o celular com mais facilidade, segurança e autonomia.',
                style: AppTextStyles.body.copyWith(color: Colors.white.withAlpha(220)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.step1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Vamos começar!', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                child: Text(
                  'Já tenho conta — entrar',
                  style: AppTextStyles.body.copyWith(color: Colors.white.withAlpha(180)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
