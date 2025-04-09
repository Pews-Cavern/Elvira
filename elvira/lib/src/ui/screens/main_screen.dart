import 'package:elvira/src/ui/widgets/icons/elvira_icon.dart';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/widgets/buttons/pew_buttons.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: elviraColorMap[ElviraColor.background],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              ElviraButton(
                label: "Lorem",
                color: ElviraColor.primary,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              ElviraIconButton(
                icon: Image.asset(ElviraIcon.elvira.path),
                label: "Lorem",
                onPressed: () {},
              ),
              const SizedBox(height: 16),

              ElviraEmergencyButton(onPressed: () => {}),
            ],
          ),
        ),
      ),
    );
  }
}
