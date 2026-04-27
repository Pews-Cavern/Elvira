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
import 'src/services/call_service.dart';
import 'src/core/services/notification_service.dart';

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
  await NotificationService.instance.init();

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
  StreamSubscription? _callSub;
  Set<int> _idsAntes = {};
  bool _redirectedToOnboarding = false;
  bool _showingCallScreen = false;

  @override
  void initState() {
    super.initState();
    CallService.instance.init();
    _callSub = CallService.instance.events.listen(_onCallEvent);
    _alarmSub = Alarm.ringing.listen((alarmSet) {
      for (final alarm in alarmSet.alarms) {
        if (!_idsAntes.contains(alarm.id)) {
          _onAlarmeDisparou(alarm);
        }
      }
      _idsAntes = alarmSet.alarms.map((a) => a.id).toSet();
    });
    // Verificar se há alarme tocando quando o app é iniciado
    WidgetsBinding.instance.addPostFrameCallback((_) => _verificarAlarmeAtivo());
  }

  /// Chamado no startup para detectar alarmes que tocaram enquanto o app estava fechado.
  Future<void> _verificarAlarmeAtivo() async {
    final isRinging = await Alarm.isRinging();
    if (!isRinging) return;
    final alarms = await Alarm.getAlarms();
    for (final alarm in alarms) {
      if (await Alarm.isRinging(alarm.id)) {
        _onAlarmeDisparou(alarm);
        break;
      }
    }
  }

  void _onCallEvent(Map<String, dynamic> e) {
    final event = e['event'] as String?;
    if (event == 'callAdded' && !_showingCallScreen) {
      _showingCallScreen = true;
      navigatorKey.currentState
          ?.pushNamed(
            AppRoutes.ligacaoAtiva,
            arguments: {
              'nome': e['name'] ?? '',
              'numero': e['number'] ?? '',
              'estado': e['state'] ?? 'dialing',
            },
          )
          .then((_) => _showingCallScreen = false);
    }
  }

  @override
  void dispose() {
    _callSub?.cancel();
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
        'alarm_id': alarm.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioProvider>(
      builder: (context, usuarioProvider, _) {
        final escala = usuarioProvider.escalaFonte;

        if (!usuarioProvider.loading &&
            !usuarioProvider.onboardingCompleto &&
            !_redirectedToOnboarding) {
          _redirectedToOnboarding = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.welcome,
              (route) => false,
            );
          });
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(escala),
          ),
          child: MaterialApp(
            title: 'Elvira',
            navigatorKey: navigatorKey,
            theme: _buildTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.home,
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