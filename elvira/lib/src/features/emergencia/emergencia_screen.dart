import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../services/call_service.dart';
import '../../core/providers/contatos_provider.dart';
import '../../core/models/contato.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/widgets/contato_avatar.dart';

class EmergenciaScreen extends StatefulWidget {
  const EmergenciaScreen({super.key});

  @override
  State<EmergenciaScreen> createState() => _EmergenciaScreenState();
}

class _EmergenciaScreenState extends State<EmergenciaScreen> {
  Timer? _sosTimer;
  bool _isPressingSOS = false;

  Future<void> _ligar(String nome, String telefone) async {
    HapticFeedback.heavyImpact();
    await CallService.instance.setCallerInfo(nome, telefone);
    await FlutterPhoneDirectCaller.callNumber(telefone);
  }

  void _startSosTimer(List<Contato> emergencia, Contato? primeiroContato) {
    setState(() => _isPressingSOS = true);
    HapticFeedback.mediumImpact();
    
    _sosTimer = Timer(const Duration(seconds: 3), () async {
      await _triggerSos(emergencia, primeiroContato);
    });
  }

  void _cancelSosTimer() {
    if (_sosTimer != null && _sosTimer!.isActive) {
      _sosTimer!.cancel();
      setState(() => _isPressingSOS = false);
    }
  }

  Future<void> _triggerSos(List<Contato> emergencia, Contato? primeiroContato) async {
    setState(() => _isPressingSOS = false);
    HapticFeedback.heavyImpact();

    final telefoneLigar = primeiroContato?.telefone ?? '192';
    final nomeLigar = primeiroContato?.nome ?? 'SAMU';

    if (emergencia.isNotEmpty) {
      try {
        final sender = SmsSender();
        const msgText = 'Preciso de ajuda imediata !\nmenssagem enviada pelo app Elvira';
        for (var c in emergencia) {
          if (c.telefone.isNotEmpty) {
            sender.sendSms(SmsMessage(c.telefone, msgText));
          }
        }
      } catch (e) {
        debugPrint('Erro ao enviar SMS: $e');
      }
    }

    await _ligar(nomeLigar, telefoneLigar);
  }

  @override
  void dispose() {
    _sosTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sosBtnSize = (screenWidth * 0.48).clamp(160.0, 200.0);

    return Scaffold(
      backgroundColor: AppColors.redLight,
      appBar: const ElviraAppBar(title: 'Emergência', backgroundColor: AppColors.red),
      body: Consumer<ContatosProvider>(
        builder: (_, provider, _) {
          final emergencia = provider.emergencia;
          final primeiroContato = emergencia.isNotEmpty ? emergencia.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTapDown: (_) => _startSosTimer(emergencia, primeiroContato),
                  onTapUp: (_) => _cancelSosTimer(),
                  onTapCancel: () => _cancelSosTimer(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isPressingSOS ? sosBtnSize * 0.95 : sosBtnSize,
                    height: _isPressingSOS ? sosBtnSize * 0.95 : sosBtnSize,
                    decoration: BoxDecoration(
                      color: _isPressingSOS ? AppColors.redMedium : AppColors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.red.withAlpha(_isPressingSOS ? 50 : 110),
                          blurRadius: _isPressingSOS ? 15 : 28,
                          spreadRadius: _isPressingSOS ? 5 : 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SOS', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 40)),
                        const SizedBox(height: 4),
                        Text(
                          _isPressingSOS ? 'SEGURE...' : 'SEGURE 3 SEG',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Precisa de ajuda?', style: AppTextStyles.h2.copyWith(color: AppColors.red)),
                const SizedBox(height: 6),
                Text(
                  'Segure o botão vermelho para pedir socorro\nou escolha um número abaixo',
                  style: AppTextStyles.body.copyWith(color: AppColors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (emergencia.isNotEmpty)
                  ...emergencia.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EmergenciaTile(contato: c, onLigar: () => _ligar(c.nome, c.telefone)),
                      )),
                const SizedBox(height: 4),
                _EmergenciaTile(
                  contato: const Contato(nome: 'SAMU', relacao: 'emergencia', telefone: '192'),
                  onLigar: () => _ligar('SAMU', '192'),
                  fixedLabel: '192',
                ),
                const SizedBox(height: 12),
                _EmergenciaTile(
                  contato: const Contato(nome: 'Bombeiros', relacao: 'emergencia', telefone: '193'),
                  onLigar: () => _ligar('Bombeiros', '193'),
                  fixedLabel: '193',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmergenciaTile extends StatelessWidget {
  final Contato contato;
  final VoidCallback onLigar;
  final String? fixedLabel;

  const _EmergenciaTile({required this.contato, required this.onLigar, this.fixedLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.redMedium, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ContatoAvatar(contato: contato, radius: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contato.nome, style: AppTextStyles.contactName),
                Text(contato.telefone, style: AppTextStyles.contactPhone),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onLigar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(88, 56),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
            child: fixedLabel != null
                ? Text(fixedLabel!, style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 20))
                : const Icon(Icons.call, size: 28),
          ),
        ],
      ),
    );
  }
}
