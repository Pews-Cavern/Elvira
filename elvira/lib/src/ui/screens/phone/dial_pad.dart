import 'package:elvira/src/ui/theme/images/elvira_number.dart';
import 'package:flutter/material.dart';

class PhoneDialScreen extends StatefulWidget {
  const PhoneDialScreen({super.key});

  @override
  State<PhoneDialScreen> createState() => _PhoneDialScreenState();
}

class _PhoneDialScreenState extends State<PhoneDialScreen> {
  String _input = '';

  void _onNumberPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Discador'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            _input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 40),
          _buildDialPad(),
          const SizedBox(height: 30),
          IconButton(
            icon: const Icon(Icons.backspace, color: Colors.white, size: 36),
            onPressed: _onBackspace,
          ),
        ],
      ),
    );
  }

  Widget _buildDialPad() {
    final List<ElviraNumber> dialButtons = [
      ElviraNumber.one, ElviraNumber.two, ElviraNumber.three,
      ElviraNumber.four, ElviraNumber.five, ElviraNumber.six,
      ElviraNumber.seven, ElviraNumber.eight, ElviraNumber.nine,
      ElviraNumber.dot,
      ElviraNumber.zero,
      ElviraNumber.dot, // usar dot como placeholder pra * e #
    ];

    final List<String> inputKeys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '*',
      '0',
      '#',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: dialButtons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
        ),
        itemBuilder: (context, index) {
          final enumValue = dialButtons[index];
          final inputChar = inputKeys[index];
          final assetPath = enumValue.path;

          return ElevatedButton(
            onPressed: () => _onNumberPressed(inputChar),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 4,
            ),
            child: Image.asset(assetPath, width: 48, height: 48),
          );
        },
      ),
    );
  }
}
