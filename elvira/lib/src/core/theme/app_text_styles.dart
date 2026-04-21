import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _family = 'Nunito';

  static TextStyle base({
    double size = 18,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
  }) =>
      TextStyle(
        fontFamily: _family,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height ?? 1.4,
        decoration: TextDecoration.none,
      );

  // Clock display
  static TextStyle clock = base(size: 56, weight: FontWeight.w700);
  static TextStyle clockDate = base(size: 20, weight: FontWeight.w500);

  // Headings
  static TextStyle h1 = base(size: 28, weight: FontWeight.w700);
  static TextStyle h2 = base(size: 24, weight: FontWeight.w700);
  static TextStyle h3 = base(size: 20, weight: FontWeight.w600);

  // Body
  static TextStyle body = base(size: 18);
  static TextStyle bodyBold = base(size: 18, weight: FontWeight.w700);
  static TextStyle bodySmall = base(size: 16); // exceção: label auxiliar

  // Buttons
  static TextStyle button = base(size: 20, weight: FontWeight.w700);
  static TextStyle buttonLarge = base(size: 22, weight: FontWeight.w800);

  // Numpad
  static TextStyle numpadDigit = base(size: 28, weight: FontWeight.w700);
  static TextStyle numpadLetters = base(size: 11, weight: FontWeight.w400, color: AppColors.textSecondary);

  // Display de número discado
  static TextStyle dialDisplay = base(size: 34, weight: FontWeight.w700);

  // Labels de ícones no launcher
  static TextStyle appLabel = base(size: 16, weight: FontWeight.w600);

  // Horário de remédio
  static TextStyle medicTime = base(size: 22, weight: FontWeight.w700, color: AppColors.primary);
  static TextStyle medicName = base(size: 20, weight: FontWeight.w700);
  static TextStyle medicDetail = base(size: 17, weight: FontWeight.w400, color: AppColors.textSecondary);

  // Contato
  static TextStyle contactName = base(size: 20, weight: FontWeight.w700);
  static TextStyle contactRelation = base(size: 16, weight: FontWeight.w500, color: AppColors.textSecondary);
  static TextStyle contactPhone = base(size: 16, weight: FontWeight.w400, color: AppColors.textSecondary);

  // Identidade
  static TextStyle idName = base(size: 26, weight: FontWeight.w700);
  static TextStyle idBloodType = base(size: 36, weight: FontWeight.w800, color: Colors.white);
  static TextStyle idLabel = base(size: 14, weight: FontWeight.w600, color: Colors.white70);

  static TextStyle onDark({double size = 18, FontWeight weight = FontWeight.w400}) =>
      base(size: size, weight: weight, color: AppColors.textOnDark);
}
