import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:provider/provider.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/prefs_service.dart';
import '../../core/services/volume_guard_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'onboarding_scaffold.dart';

class Step6AudioScreen extends StatefulWidget {
  const Step6AudioScreen({super.key});

  @override
  State<Step6AudioScreen> createState() => _Step6AudioScreenState();
}

class _Step6AudioScreenState extends State<Step6AudioScreen> {
  static const _niveis = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  int _nivel = 0;
  bool _tocando = false;
  bool _calibrado = false;
  final _player = AudioPlayer();
  late final double _minimoAnterior;

  @override
  void initState() {
    super.initState();
    FlutterVolumeController.updateShowSystemUI(false);
    _minimoAnterior = VolumeGuardService.instance.minimoAtual;
    VolumeGuardService.instance.pausar();
  }

  @override
  void dispose() {
    _player.dispose();
    if (!_calibrado) {
      VolumeGuardService.instance.retomarCom(_minimoAnterior);
    }
    super.dispose();
  }

  Future<void> _tocar() async {
    if (_tocando) return;
    setState(() => _tocando = true);
    await FlutterVolumeController.setVolume(_niveis[_nivel]);
    await _player.stop();
    await _player.setVolume(1.0);
    await _player.play(AssetSource('sounds/pills.mp3'));
    await Future.delayed(const Duration(seconds: 3));
    await _player.stop();
    if (mounted) setState(() => _tocando = false);
  }

  Future<void> _ouvi() async {
    await _player.stop();
    final escolhido = _niveis[_nivel];
    await PrefsService.instance.setVolumeCalibracao(escolhido);
    await VolumeGuardService.instance.retomarCom(escolhido);
    if (mounted) setState(() => _calibrado = true);
  }

  Future<void> _maisAlto() async {
    if (_nivel < _niveis.length - 1) {
      setState(() => _nivel++);
      await _tocar();
    } else {
      await _ouvi();
    }
  }

  Future<void> _concluir() async {
    await context.read<UsuarioProvider>().concluirOnboarding();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 6,
      totalSteps: 6,
      emoji: '🔊',
      titulo: 'Ajuste o volume',
      subtitulo: 'Vamos encontrar o volume ideal para você ouvir bem',
      continuarHabilitado: _calibrado,
      labelContinuar: 'Pronto! Entrar no app',
      onContinuar: _concluir,
      onVoltar: () => Navigator.pop(context),
      content: Column(
        children: [
          const SizedBox(height: 8),
          if (_calibrado)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.green),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Volume salvo: ${(_niveis[_nivel] * 100).round()}%',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Os alarmes vão tocar neste volume. O celular não vai abaixar mais que isso.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.blueXLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight, width: 2),
              ),
              child: Column(
                children: [
                  Icon(
                    _tocando ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Volume: ${(_niveis[_nivel] * 100).round()}%',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nível ${_nivel + 1} de ${_niveis.length}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _tocando ? null : _tocar,
                icon: const Icon(Icons.volume_up, size: 26),
                label: Text(
                  _tocando ? 'Tocando...' : 'TOCAR',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _tocando ? null : _ouvi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Ouvi!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _tocando ? null : _maisAlto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        _nivel < _niveis.length - 1 ? 'Mais alto' : 'Máximo',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Toque em TOCAR e depois diga se ouviu o som.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
