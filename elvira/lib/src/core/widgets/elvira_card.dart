import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ElviraCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color color;
  final double borderRadius;
  final Border? border;

  const ElviraCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.cardBackground,
    this.borderRadius = 16,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: border != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: border,
                )
              : null,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
