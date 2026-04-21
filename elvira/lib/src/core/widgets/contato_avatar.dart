import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/contato.dart';

class ContatoAvatar extends StatelessWidget {
  final Contato contato;
  final double radius;

  const ContatoAvatar({super.key, required this.contato, this.radius = 28});

  Color get _color {
    switch (contato.relacao) {
      case 'familiar':
        return AppColors.blueLight;
      case 'medico':
        return const Color(0xFFFFDBC1);
      case 'cuidador':
        return AppColors.greenLight;
      case 'emergencia':
        return AppColors.redLight;
      default:
        return AppColors.blueXLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _color,
      child: Text(
        contato.initials,
        style: AppTextStyles.bodyBold.copyWith(
          color: AppColors.primary,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
