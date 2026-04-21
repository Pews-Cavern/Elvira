import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/core/db/database_helper.dart';
import 'src/core/providers/usuario_provider.dart';
import 'src/core/providers/contatos_provider.dart';
import 'src/core/providers/medicamentos_provider.dart';
import 'src/core/providers/dose_provider.dart';
import 'src/core/routes/app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await initializeDateFormatting('pt_BR', null);
  await DatabaseHelper.instance.database;
  await Alarm.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()..init()),
        ChangeNotifierProvider(create: (_) => ContatosProvider()..init()),
        ChangeNotifierProvider(create: (_) => MedicamentosProvider()..init()),
        ChangeNotifierProvider(create: (_) => DoseProvider()..init()),
      ],
      child: const ElviraApp(),
    ),
  );
}

class ElviraApp extends StatefulWidget {
  const ElviraApp({super.key});

  @override
  State<ElviraApp> createState() => _ElviraAppState();
}

class _ElviraAppState extends State<ElviraApp> {
  StreamSubscription<AlarmSet>? _alarmSub;
  Set<int> _idsAntes = {};

  @override
  void initState() {
    super.initState();
    _alarmSub = Alarm.ringing.listen((alarmSet) {
      for (final alarm in alarmSet.alarms) {
        if (!_idsAntes.contains(alarm.id)) {
          _onAlarmeDisparou(alarm);
        }
      }
      _idsAntes = alarmSet.alarms.map((a) => a.id).toSet();
    });
  }

  @override
  void dispose() {
    _alarmSub?.cancel();
    super.dispose();
  }

  void _onAlarmeDisparou(AlarmSettings alarm) {
    final doseProvider = navigatorKey.currentContext?.read<DoseProvider>();

    final registro = doseProvider?.registrosHoje
        .where((r) => r.doseId == alarm.id)
        .firstOrNull;

    final partes = alarm.notificationSettings.body.split(' — ');
    final nomeRemedio = partes.isNotEmpty ? partes[0] : 'Remédio';
    final dosagem = partes.length > 1 ? partes[1] : '';

    final hora =
        '${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')}';

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.alarme,
      (route) => route.settings.name == AppRoutes.home,
      arguments: {
        'nome': nomeRemedio,
        'dosagem': dosagem,
        'instrucao': '',
        'hora': hora,
        'registro_id': registro?.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioProvider>(
      builder: (context, usuarioProvider, _) {
        final escala = usuarioProvider.escalaFonte;
        final initialRoute = usuarioProvider.loading
            ? AppRoutes.home
            : usuarioProvider.onboardingCompleto
                ? AppRoutes.home
                : AppRoutes.welcome;

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(escala),
          ),
          child: MaterialApp(
            title: 'Elvira',
            navigatorKey: navigatorKey,
            theme: _buildTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0C447C),
        primary: const Color(0xFF0C447C),
        secondary: const Color(0xFF185FA5),
        surface: Colors.white,
        error: const Color(0xFFA32D2D),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      fontFamily: 'Nunito',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0C447C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(64),
          backgroundColor: const Color(0xFF0C447C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFB5D4F4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFB5D4F4), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0C447C), width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          color: Color(0xFF888780),
        ),
      ),
    );
  }
}