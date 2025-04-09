import 'package:flutter/material.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:elvira/src/ui/widgets/icons/elvira_icon.dart';

class ElviraIconButton extends StatelessWidget {
  final Image icon;
  final String label;
  final VoidCallback onPressed;
  final ElviraColor color;

  const ElviraIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = ElviraColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
        minWidth: 180,
        minHeight: 70,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: elviraColorMap[color],
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ElviraIcon.elvira.path,
              
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                textWidthBasis: TextWidthBasis.longestLine,
                softWrap: true,
                //overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
