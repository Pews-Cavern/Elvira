import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/providers/usuario_provider.dart';

class ElviraApp extends StatefulWidget {
  const ElviraApp({super.key});

  @override
  State<ElviraApp> createState() => _ElviraAppState();
}

class _ElviraAppState extends State<ElviraApp> {
  bool _localeReady = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null).then((_) {
      if (mounted) setState(() => _localeReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeReady) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return Consumer<UsuarioProvider>(
      builder: (context, usuarioProvider, _) {
        final escala = usuarioProvider.escalaFonte;
        final initialRoute = usuarioProvider.loading
            ? AppRoutes.home
            : usuarioProvider.onboardingCompleto
                ? AppRoutes.home
                : AppRoutes.welcome;

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(escala)),
          child: MaterialApp(
            title: 'Elvira',
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
