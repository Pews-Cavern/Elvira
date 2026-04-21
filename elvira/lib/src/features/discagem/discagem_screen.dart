import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';

class DiscagemScreen extends StatefulWidget {
  const DiscagemScreen({super.key});

  @override
  State<DiscagemScreen> createState() => _DiscagemScreenState();
}

class _DiscagemScreenState extends State<DiscagemScreen> {
  String _numero = '';

  static const _teclas = [
    {'d': '1', 'l': ''},
    {'d': '2', 'l': 'ABC'},
    {'d': '3', 'l': 'DEF'},
    {'d': '4', 'l': 'GHI'},
    {'d': '5', 'l': 'JKL'},
    {'d': '6', 'l': 'MNO'},
    {'d': '7', 'l': 'PQRS'},
    {'d': '8', 'l': 'TUV'},
    {'d': '9', 'l': 'WXYZ'},
    {'d': '*', 'l': ''},
    {'d': '0', 'l': '+'},
    {'d': '#', 'l': ''},
  ];

  void _digitar(String d) => setState(() => _numero += d);
  void _apagar() => setState(() {
        if (_numero.isNotEmpty) _numero = _numero.substring(0, _numero.length - 1);
      });

  Future<void> _ligar() async {
    if (_numero.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: _numero);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String get _numeroFormatado {
    if (_numero.length <= 2) return _numero;
    if (_numero.length <= 7) return '(${_numero.substring(0, 2)}) ${_numero.substring(2)}';
    return '(${_numero.substring(0, 2)}) ${_numero.substring(2, 7)}-${_numero.substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Discagem'),
      body: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            color: AppColors.primary,
            child: Column(
              children: [
                Text(
                  _numero.isEmpty ? '' : _numeroFormatado,
                  style: AppTextStyles.dialDisplay.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _numero.isEmpty ? 'Digite o número' : '',
                  style: AppTextStyles.body.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          // Numpad
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemCount: _teclas.length,
                itemBuilder: (_, i) => _NumpadKey(
                  digito: _teclas[i]['d']!,
                  letras: _teclas[i]['l']!,
                  onTap: () => _digitar(_teclas[i]['d']!),
                ),
              ),
            ),
          ),
          // Ações
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Row(
              children: [
                _ActionBtn(
                  icon: Icons.backspace_outlined,
                  color: AppColors.background,
                  iconColor: AppColors.textPrimary,
                  onTap: _apagar,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 72,
                    child: ElevatedButton(
                      onPressed: _numero.isNotEmpty ? _ligar : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Icon(Icons.call, size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _ActionBtn(
                  icon: Icons.call_end,
                  color: AppColors.redLight,
                  iconColor: AppColors.red,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  final String digito;
  final String letras;
  final VoidCallback onTap;

  const _NumpadKey({required this.digito, required this.letras, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(digito, style: AppTextStyles.numpadDigit),
            if (letras.isNotEmpty) Text(letras, style: AppTextStyles.numpadLetters),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.color, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }
}
