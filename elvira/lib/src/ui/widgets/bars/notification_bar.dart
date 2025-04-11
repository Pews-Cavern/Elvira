import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:flutter/material.dart';

class NotificationBar extends StatefulWidget {
  const NotificationBar({super.key});

  @override
  State<NotificationBar> createState() => _NotificationBarState();
}

class _NotificationBarState extends State<NotificationBar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: elviraColorMap[ElviraColor.surface],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Paulo telefonou para você a 5 minutos atrás',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
