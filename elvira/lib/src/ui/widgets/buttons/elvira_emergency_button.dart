import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/widgets/buttons/elvira_button.dart';

class ElviraEmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ElviraEmergencyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElviraButton(
      label: 'Emergência',
      color: ElviraColor.error,
      onPressed: onPressed,
    );
  }
}
