import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:flutter/material.dart';

class ElviraButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ElviraColor color;
  final Color textColor;

  const ElviraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = ElviraColor.primary,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 180,
      height: 90,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: elviraColorMap[color],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: textColor),
          ),
        ),
      ),
    );
  }
}
