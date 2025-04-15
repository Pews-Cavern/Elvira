import 'package:flutter/material.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';

class ElviraModal extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const ElviraModal({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: elviraColorMap[ElviraColor.surface],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screen.width * 0.85, // ISSO AQUI, SEU DESGRAÇADO
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screen.width * 0.06,
                color: elviraColorMap[ElviraColor.onBackground],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            content,
            const SizedBox(height: 32),
            ...actions.map((widget) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: widget,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
