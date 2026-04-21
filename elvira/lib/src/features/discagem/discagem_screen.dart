import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _digitar(String d) {
    HapticFeedback.lightImpact();
    setState(() => _numero += d);
  }

  void _apagar() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_numero.isNotEmpty) _numero = _numero.substring(0, _numero.length - 1);
    });
  }

  void _apagarTudo() {
    HapticFeedback.mediumImpact();
    setState(() => _numero = '');
  }

  Future<void> _ligar() async {
    if (_numero.isEmpty) return;
    HapticFeedback.heavyImpact();
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            color: AppColors.primary,
            child: Column(
              children: [
                Text(
                  _numero.isEmpty ? 'Digite o número' : _numeroFormatado,
                  style: AppTextStyles.dialDisplay.copyWith(
                    color: _numero.isEmpty ? Colors.white54 : Colors.white,
                    fontSize: 36,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                GestureDetector(
                  onLongPress: _apagarTudo,
                  child: _ActionBtn(
                    icon: Icons.backspace_outlined,
                    color: Colors.white,
                    iconColor: AppColors.textPrimary,
                    onTap: _apagar,
                    tooltip: 'Apagar',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 76,
                    child: ElevatedButton(
                      onPressed: _numero.isNotEmpty ? _ligar : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        disabledBackgroundColor: AppColors.green.withAlpha(80),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Icon(Icons.call, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _ActionBtn(
                  icon: Icons.arrow_back,
                  color: AppColors.redLight,
                  iconColor: AppColors.red,
                  onTap: () => Navigator.pop(context),
                  tooltip: 'Voltar',
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
  final String tooltip;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 76,
            height: 76,
            child: Icon(icon, color: iconColor, size: 30),
          ),
        ),
      ),
    );
  }
}
