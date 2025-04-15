import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:elvira/src/ui/theme/images/elvira_number.dart';

class PhoneDialScreen extends StatefulWidget {
  const PhoneDialScreen({super.key});

  @override
  State<PhoneDialScreen> createState() => _PhoneDialScreenState();
}

class _PhoneDialScreenState extends State<PhoneDialScreen> {
  String _input = '';
  DateTime? _lastOpened;

  @override
  void initState() {
    super.initState();
    _loadSavedInput();
  }

  Future<void> _loadSavedInput() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('dial_input') ?? '';
    final last = prefs.getInt('dial_last') ?? 0;

    final now = DateTime.now();
    final savedTime = DateTime.fromMillisecondsSinceEpoch(last);

    if (now.difference(savedTime).inMinutes >= 0.2) {
      await prefs.remove('dial_input');
      await prefs.remove('dial_last');
    } else {
      setState(() {
        _input = saved;
        _lastOpened = savedTime;
      });
    }
  }

  Future<void> _saveInput() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dial_input', _input);
    await prefs.setInt('dial_last', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _clearSavedInput() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dial_input');
    await prefs.remove('dial_last');
  }

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

  void _makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: _input);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      await _clearSavedInput(); // limpa após chamada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível fazer a ligação')),
      );
    }
  }

  @override
  void dispose() {
    _saveInput(); // salva ao sair
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Discador',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: elviraColorMap[ElviraColor.onBackground],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
            child: Center(
              child: Text(
                _input,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.09,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Flexible(child: _buildDialPad(size)),
          SizedBox(height: size.height * 0.03),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: size.height * 0.08,
                  child: ElevatedButton.icon(
                    onPressed: _onBackspace,
                    icon: const Icon(Icons.backspace, size: 32),
                    label: const Text('Apagar', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: size.height * 0.08,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_input.isNotEmpty) {
                        _makeCall();
                      }
                    },
                    icon: const Icon(Icons.call, size: 32),
                    label: const Text('Ligar', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _input.isNotEmpty ? Colors.green : Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialPad(Size size) {
    final List<ElviraNumber> dialButtons = [
      ElviraNumber.one,
      ElviraNumber.two,
      ElviraNumber.three,
      ElviraNumber.four,
      ElviraNumber.five,
      ElviraNumber.six,
      ElviraNumber.seven,
      ElviraNumber.eight,
      ElviraNumber.nine,
      ElviraNumber.asterisk,
      ElviraNumber.zero,
      ElviraNumber.hashtag,
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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
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
              padding: EdgeInsets.all(size.width * 0.05),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Image.asset(
              assetPath,
              width: size.width * 0.12,
              height: size.width * 0.12,
            ),
          );
        },
      ),
    );
  }
}
