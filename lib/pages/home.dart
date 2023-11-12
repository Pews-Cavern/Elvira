import 'dart:async';

import 'package:Elvira/util/battery.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer _timer;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _timeString = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: const Color.fromARGB(255, 91, 91, 91),
            child: Column(
              children: [
                const Spacer(
                  flex: 5,
                ),
                Text(
                  _timeString,
                  style: const TextStyle(
                    fontSize: 50,
                    color: Color.fromARGB(255, 246, 246, 246),
                    backgroundColor: Colors.black,
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                BatteryWidget(batteryLevel: int.parse(Battery().level())),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button 1'),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button 1.2'),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button 2'),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button 3'),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button 4'),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class BatteryWidget extends StatelessWidget {
  final int batteryLevel;
  final double width;
  final double height;

  const BatteryWidget({
    required this.batteryLevel,
    this.width = 300,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            width: batteryLevel.toDouble() * (this.width / 100),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "$batteryLevel%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
