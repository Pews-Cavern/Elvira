import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../services/call_service.dart';

class LigacaoAtivaScreen extends StatefulWidget {
  final String nome;
  final String numero;
  final String estadoInicial;

  const LigacaoAtivaScreen({
    super.key,
    required this.nome,
    required this.numero,
    required this.estadoInicial,
  });

  @override
  State<LigacaoAtivaScreen> createState() => _LigacaoAtivaScreenState();
}

class _LigacaoAtivaScreenState extends State<LigacaoAtivaScreen> {
  String _estado = '';
  bool _speaker = true;
  int _segundos = 0;
  Timer? _timer;
  StreamSubscription? _callSub;

  @override
  void initState() {
    super.initState();
    _estado = widget.estadoInicial;

    CallService.instance.setSpeaker(true);

    if (_estado == 'active') _startTimer();

    _callSub = CallService.instance.events.listen(_onEvent);

    // Check if call already ended before screen opened
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = await CallService.instance.getCurrentState();
      if ((state == null || state == 'disconnected' || state == 'disconnecting') &&
          mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _onEvent(Map<String, dynamic> e) {
    final event = e['event'] as String?;
    final state = e['state'] as String?;

    if (event == 'stateChanged') {
      setState(() => _estado = state ?? _estado);
      if (state == 'active' && _timer == null) _startTimer();
      if (state == 'disconnected' || state == 'disconnecting') _fechar();
    } else if (event == 'callRemoved') {
      _fechar();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _segundos++);
    });
  }

  String get _timerLabel {
    final m = (_segundos ~/ 60).toString().padLeft(2, '0');
    final s = (_segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _statusLabel {
    switch (_estado) {
      case 'dialing':
      case 'ringing':
        return 'Chamando...';
      case 'active':
        return _timerLabel;
      case 'holding':
        return 'Em espera';
      case 'disconnecting':
      case 'disconnected':
        return 'Encerrando...';
      default:
        return 'Conectando...';
    }
  }

  bool get _ativo => _estado == 'active';

  Future<void> _toggleSpeaker() async {
    HapticFeedback.lightImpact();
    final novo = !_speaker;
    await CallService.instance.setSpeaker(novo);
    if (mounted) setState(() => _speaker = novo);
  }

  Future<void> _encerrar() async {
    HapticFeedback.heavyImpact();
    await CallService.instance.endCall();
  }

  void _fechar() {
    _timer?.cancel();
    _callSub?.cancel();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _callSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inicial = widget.nome.isNotEmpty
        ? widget.nome[0].toUpperCase()
        : widget.numero.isNotEmpty
            ? widget.numero[0]
            : '?';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF071428),
        body: SafeArea(
          child: Column(
            children: [
              // ─── Informações do contato ────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: _ativo ? AppColors.greenLight : Colors.white24,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          inicial,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      widget.nome.isNotEmpty ? widget.nome : widget.numero,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.nome.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.numero,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white60,
                          fontSize: 18,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: _ativo ? AppColors.greenLight : Colors.white70,
                        fontSize: _ativo ? 24 : 18,
                        fontWeight: _ativo ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Controles ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 0, 48, 52),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BotaoRedondo(
                      icon: _speaker
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      label: 'Viva-voz',
                      ativo: _speaker,
                      onTap: _toggleSpeaker,
                    ),
                    _BotaoEncerrar(onTap: _encerrar),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoRedondo extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool ativo;
  final VoidCallback onTap;

  const _BotaoRedondo({
    required this.icon,
    required this.label,
    required this.ativo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ativo ? Colors.white24 : Colors.transparent,
              border: Border.all(color: Colors.white54, width: 2),
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotaoEncerrar extends StatelessWidget {
  final VoidCallback onTap;

  const _BotaoEncerrar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.red,
            ),
            child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 10),
          const Text(
            'Encerrar',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
