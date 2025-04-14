import 'package:elvira/src/ui/screens/phone/call_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/screens/main_screen.dart';
import 'package:elvira/src/ui/screens/phone/phone_screen.dart';
import 'package:elvira/src/ui/screens/phone/dial_pad.dart';

class AppRoutes {
  static const String home = '/';
  static const String phone = '/phone';
  static const String dialPad = '/phone/dial_pad';
  static const String callHistory = '/phone/call_history_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case phone:
        return MaterialPageRoute(builder: (_) => const PhoneScreen());
      case dialPad:
        return MaterialPageRoute(builder: (_) => const PhoneDialScreen());
      case callHistory:
        return MaterialPageRoute(builder: (_) => const CallHistoryScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('Tela "${settings.name}" não existe')),
              ),
        );
    }
  }
}
