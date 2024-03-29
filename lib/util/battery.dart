import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/android_battery_info.dart';

class Battery {
  static final Battery _Battery = Battery._internal();
  factory Battery() {
    return _Battery;
  }
  Battery._internal();

  late BatteryInfoPlugin bt;
  late AndroidBatteryInfo? battery;
  void init() async {
    bt = BatteryInfoPlugin();
    battery = await (bt.androidBatteryInfo);
  }

  String health() {
    return battery!.health.toString();
  }

  String level() {
    return battery!.batteryLevel.toString();
  }

  bool isChargin() {
    return battery!.chargingStatus.toString().split(".")[1] == "Charging"
        ? true
        : false;
  }

  int getChargeTime() {
    return (battery!.chargeTimeRemaining! / 1000 / 60).truncate();
  }
}
