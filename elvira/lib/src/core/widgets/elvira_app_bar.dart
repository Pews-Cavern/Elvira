import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ElviraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Color backgroundColor;

  const ElviraAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.backgroundColor = AppColors.primary,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: showBack,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 26),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(title),
      actions: actions,
      elevation: 0,
    );
  }
}
