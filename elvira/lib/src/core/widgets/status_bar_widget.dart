import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatusBarWidget extends StatefulWidget {
  final Color textColor;
  const StatusBarWidget({super.key, this.textColor = Colors.white});

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  final _battery = Battery();
  Timer? _timer;
  DateTime _now = DateTime.now();
  int _batteryLevel = 100;
  bool _charging = false;

  @override
  void initState() {
    super.initState();
    _updateBattery();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateBattery();
      setState(() => _now = DateTime.now());
    });
  }

  Future<void> _updateBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      if (mounted) {
        setState(() {
          _batteryLevel = level;
          _charging = state == BatteryState.charging;
          _now = DateTime.now();
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color get _batteryColor {
    if (_charging) return AppColors.greenLight;
    if (_batteryLevel <= 20) return AppColors.redMedium;
    if (_batteryLevel <= 50) return AppColors.amber;
    return AppColors.greenLight;
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(_now);
    final dateStr = DateFormat("EEE, d 'de' MMMM", 'pt_BR').format(_now);

    return Column(
      children: [
        Text(timeStr, style: AppTextStyles.clock.copyWith(color: widget.textColor, fontSize: 60)),
        const SizedBox(height: 4),
        Text(dateStr, style: AppTextStyles.clockDate.copyWith(color: widget.textColor.withAlpha(220))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _charging ? Icons.battery_charging_full : Icons.battery_full,
              color: _batteryColor,
              size: 26,
            ),
            const SizedBox(width: 6),
            Text(
              '$_batteryLevel%',
              style: AppTextStyles.body.copyWith(color: _batteryColor, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
