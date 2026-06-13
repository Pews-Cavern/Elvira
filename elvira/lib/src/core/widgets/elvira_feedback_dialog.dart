import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum FeedbackType { success, error, info }

Future<void> showFeedbackDialog(
  BuildContext context, {
  required String message,
  String? title,
  FeedbackType type = FeedbackType.success,
}) {
  final IconData icon;
  final Color color;
  switch (type) {
    case FeedbackType.success:
      icon = Icons.check_circle_rounded;
      color = AppColors.green;
      break;
    case FeedbackType.error:
      icon = Icons.error_rounded;
      color = AppColors.red;
      break;
    case FeedbackType.info:
      icon = Icons.info_rounded;
      color = AppColors.amber;
      break;
  }

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Icon(icon, color: color, size: 48),
      title: title != null
          ? Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center)
          : null,
      content: Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 120,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('OK', style: AppTextStyles.button.copyWith(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}
