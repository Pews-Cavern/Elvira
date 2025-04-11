import 'dart:async';
import 'package:elvira/src/ui/widgets/bars/notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';

class TopStatusBar extends StatefulWidget implements PreferredSizeWidget {
  const TopStatusBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(250.0);

  @override
  State<TopStatusBar> createState() => _TopStatusBarState();
}

class _TopStatusBarState extends State<TopStatusBar> {
  late Timer _timer;
  String _currentTime = '';
  int _batteryLevel = 0;
  String _connectionStatus = '...';

  final Battery _battery = Battery();
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _updateAll();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateAll());
  }

  Future<void> _updateAll() async {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);
    final battery = await _battery.batteryLevel;
    final conn = await _connectivity.checkConnectivity();

    setState(() {
      _currentTime = formattedTime;
      _batteryLevel = battery;
      _connectionStatus = _getConnectionLabel(conn);
    });
  }

  String _getConnectionLabel(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return '4G';
      case ConnectivityResult.none:
        return 'Sem sinal';
      default:
        return '...';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    _connectionStatus,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.battery_full,
                    color: Colors.white,
                    size: 100,
                  ),
                  Text(
                    '$_batteryLevel%',
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
              const SizedBox(width: 1),
              NotificationBar(),
            ],
          ),
        ],
      ),
    );
  }
}
