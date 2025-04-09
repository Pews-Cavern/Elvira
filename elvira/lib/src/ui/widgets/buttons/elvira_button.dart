import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:flutter/material.dart';

class ElviraButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final ElviraColor color;
  final Color textColor = Colors.white;

  static void _defaultOnLongPress() {}

  const ElviraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress = _defaultOnLongPress,
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
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: elviraColorMap[color],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          textWidthBasis: TextWidthBasis.longestLine,
          softWrap: true,
          //overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
