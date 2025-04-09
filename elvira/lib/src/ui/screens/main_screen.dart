import 'package:flutter/material.dart';
import 'package:elvira/src/ui/widgets/buttons/pew_buttons.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          elviraColorMap[ElviraColor.background], // fundo escuro básico
      body: SafeArea(
        child: Center(
          child: ElviraButton(
            label: "Teste",
          
            onPressed: () {
              // faz algo aqui, ou só finge que vai fazer
            },
          ),
        ),
      ),
    );
  }
}
