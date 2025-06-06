import 'package:elvira/src/config/routes.dart';
import 'package:elvira/src/ui/theme/images/elvira_icon.dart';
import 'package:elvira/src/ui/widgets/bars/top_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/widgets/buttons/pew_buttons.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: elviraColorMap[ElviraColor.background],
      appBar: TopStatusBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double gridWidth = constraints.maxWidth;
              final double gridHeight = constraints.maxHeight;
              final double itemHeight =
                  (gridHeight - 40) / 3; // considerando espaçamento
              final double itemWidth = (gridWidth - 40) / 2;

              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: itemWidth / itemHeight,
                children: [
                  HomeFeatureButton(
                    onPressed:
                        () => Navigator.pushNamed(context, AppRoutes.phone),
                    icon: Image.asset(ElviraIcon.phone.path),
                    label: 'Telefone',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                  HomeFeatureButton(
                    onPressed: () => print('clicou'),
                    icon: Image.asset(ElviraIcon.medicine.path),
                    label: 'Medicamentos',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                  HomeFeatureButton(
                    onPressed: () => print('clicou'),
                    icon: Image.asset(ElviraIcon.emergency.path),
                    label: 'Emergência',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                  HomeFeatureButton(
                    onPressed: () => print('clicou'),
                    icon: Image.asset(ElviraIcon.cogwheel.path),
                    label: 'Configurações',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                 
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/*-*/

class HomeFeatureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const HomeFeatureButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(8),
          elevation: 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: icon),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
