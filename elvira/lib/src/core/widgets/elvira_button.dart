import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ElviraButtonVariant { primary, success, danger, amber, outline }

class ElviraButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ElviraButtonVariant variant;
  final IconData? icon;
  final double height;
  final bool fullWidth;

  const ElviraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ElviraButtonVariant.primary,
    this.icon,
    this.height = 64,
    this.fullWidth = true,
  });

  Color get _bg {
    switch (variant) {
      case ElviraButtonVariant.success:
        return AppColors.green;
      case ElviraButtonVariant.danger:
        return AppColors.red;
      case ElviraButtonVariant.amber:
        return AppColors.amber;
      case ElviraButtonVariant.outline:
        return Colors.transparent;
      default:
        return AppColors.primary;
    }
  }

  Color get _fg {
    if (variant == ElviraButtonVariant.outline) return AppColors.primary;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      minimumSize: Size(fullWidth ? double.infinity : 120, height),
      backgroundColor: _bg,
      foregroundColor: _fg,
      elevation: variant == ElviraButtonVariant.outline ? 0 : 2,
      side: variant == ElviraButtonVariant.outline
          ? const BorderSide(color: AppColors.primary, width: 2)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    final child = icon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26),
              const SizedBox(width: 10),
              Text(label, style: AppTextStyles.button.copyWith(color: _fg)),
            ],
          )
        : Text(label, style: AppTextStyles.button.copyWith(color: _fg));

    return ElevatedButton(onPressed: onPressed, style: style, child: child);
  }
}
