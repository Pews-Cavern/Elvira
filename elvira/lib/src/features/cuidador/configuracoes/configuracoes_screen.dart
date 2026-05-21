import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/db/database_helper.dart';
import '../../../core/providers/contatos_provider.dart';
import '../../../core/providers/dose_provider.dart';
import '../../../core/providers/medicamentos_provider.dart';
import '../../../core/providers/usuario_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/alarm_service.dart';
import '../../../core/services/prefs_service.dart';
import '../../../core/services/volume_guard_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';
import '../../../services/call_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _pinAtualCtrl = TextEditingController();
  final _pinNovoCtrl = TextEditingController();
  final _pinConfCtrl = TextEditingController();
  double _escala = 1.0;
  bool? _isDefaultDialer;
  SomAlarme? _somAtual;
  double _volumeCalibracao = 1.0;

  @override
  void initState() {
    super.initState();
    _escala = context.read<UsuarioProvider>().escalaFonte;
    _checkDefaultDialer();
    _carregarSom();
    _carregarVolume();
  }

  Future<void> _carregarVolume() async {
    final v = await PrefsService.instance.getVolumeCalibracao();
    if (mounted) setState(() => _volumeCalibracao = v);
  }

  Future<void> _carregarSom() async {
    final som = await PrefsService.instance.getSomAlarme();
    if (mounted) setState(() => _somAtual = som);
  }

  Future<void> _salvarSom(SomAlarme som) async {
    await PrefsService.instance.setSomAlarme(som.id);
    setState(() => _somAtual = som);
    if (!mounted) return;
    // Preview: toca 2 segundos do novo som
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: 99999,
        dateTime: DateTime.now().add(const Duration(seconds: 1)),
        assetAudioPath: som.assetPath,
        loopAudio: false,
        vibrate: false,
        warningNotificationOnKill: false,
        androidFullScreenIntent: false,
        volumeSettings: VolumeSettings.fixed(volume: 0.8),
        notificationSettings: const NotificationSettings(
          title: 'Elvira',
          body: 'Testando som...',
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 3));
    await Alarm.stop(99999);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Som salvo: ${som.nome}', style: AppTextStyles.body)),
      );
    }
  }

  Future<void> _mostrarDialogoCalibracao() async {
    final niveis = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
    int nivel = 0;
    bool tocando = false;
    final player = AudioPlayer();
    final minimoAnterior = VolumeGuardService.instance.minimoAtual;
    FlutterVolumeController.updateShowSystemUI(false);
    VolumeGuardService.instance.pausar();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) {
          Future<void> tocar() async {
            if (tocando) return;
            setD(() => tocando = true);
            await FlutterVolumeController.setVolume(niveis[nivel]);
            await player.stop();
            await player.setVolume(1.0);
            await player.play(AssetSource('sounds/pills.mp3'));
            await Future.delayed(const Duration(seconds: 3));
            await player.stop();
            if (ctx.mounted) setD(() => tocando = false);
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Ajustar volume', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tocando ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Toque em TOCAR e nos diga\nse conseguiu ouvir o som.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nível ${nivel + 1} de ${niveis.length}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: tocando ? null : tocar,
                    icon: const Icon(Icons.volume_up, size: 24),
                    label: Text(
                      tocando ? 'Tocando...' : 'TOCAR',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: tocando
                            ? null
                            : () async {
                                await player.stop();
                                final escolhido = niveis[nivel];
                                await PrefsService.instance
                                    .setVolumeCalibracao(escolhido);
                                await VolumeGuardService.instance
                                    .retomarCom(escolhido);
                                if (ctx.mounted) Navigator.pop(ctx, true);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Ouvi!'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: tocando
                            ? null
                            : () async {
                                if (nivel < niveis.length - 1) {
                                  setD(() => nivel++);
                                  await tocar();
                                } else {
                                  await player.stop();
                                  await PrefsService.instance
                                      .setVolumeCalibracao(1.0);
                                  await VolumeGuardService.instance
                                      .retomarCom(1.0);
                                  if (ctx.mounted) Navigator.pop(ctx, true);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: Text(nivel < niveis.length - 1
                            ? 'Mais alto'
                            : 'Máximo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: tocando
                    ? null
                    : () async {
                        await player.stop();
                        await player.dispose();
                        await VolumeGuardService.instance
                            .retomarCom(minimoAnterior);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      ),
    );

    await _carregarVolume();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Volume calibrado: ${(_volumeCalibracao * 100).round()}%',
            style: AppTextStyles.body,
          ),
        ),
      );
    }
  }

  Future<void> _resetarApp() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 32),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Resetar o aplicativo?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todos os dados serão apagados:', style: AppTextStyles.body),
            const SizedBox(height: 8),
            Text('• Nome e foto do idoso', style: AppTextStyles.bodySmall),
            Text('• Contatos e cuidadores', style: AppTextStyles.bodySmall),
            Text('• Remédios e alarmes', style: AppTextStyles.bodySmall),
            Text('• Calibrações de texto e volume', style: AppTextStyles.bodySmall),
            Text('• PIN do cuidador', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            Text(
              'Esta ação não pode ser desfeita.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, resetar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    await AlarmService.cancelarTodos();

    final db = await DatabaseHelper.instance.database;
    await db.delete('registro_dose');
    await db.delete('dose_medicamento');
    await db.delete('medicamento');
    await db.delete('contato');
    await db.delete('usuario');
    await db.delete('log_uso');

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await VolumeGuardService.instance.retomarCom(0.0);

    if (!mounted) return;
    await context.read<UsuarioProvider>().init();
    if (!mounted) return;
    await context.read<ContatosProvider>().init();
    if (!mounted) return;
    await context.read<MedicamentosProvider>().init();
    if (!mounted) return;
    await context.read<DoseProvider>().init();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (_) => false);
  }

  Future<void> _checkDefaultDialer() async {
    final v = await CallService.instance.isDefaultDialer();
    if (mounted) setState(() => _isDefaultDialer = v);
  }

  @override
  void dispose() {
    _pinAtualCtrl.dispose();
    _pinNovoCtrl.dispose();
    _pinConfCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvarEscala() async {
    await context.read<UsuarioProvider>().atualizarEscalaFonte(_escala);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tamanho do texto salvo!', style: AppTextStyles.body)),
      );
    }
  }

  Future<void> _trocarPin() async {
    final provider = context.read<UsuarioProvider>();
    final ok = await provider.verificarPin(_pinAtualCtrl.text);
    if (!ok) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN atual incorreto', style: AppTextStyles.body)));
      return;
    }
    if (_pinNovoCtrl.text != _pinConfCtrl.text || _pinNovoCtrl.text.length != 4) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PINs não conferem', style: AppTextStyles.body)));
      return;
    }
    await provider.definirPin(_pinNovoCtrl.text);
    _pinAtualCtrl.clear();
    _pinNovoCtrl.clear();
    _pinConfCtrl.clear();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN alterado com sucesso!', style: AppTextStyles.body)));
  }

  @override
  Widget build(BuildContext context) {
    final escalas = [1.0, 1.15, 1.3, 1.5, 1.7];
    final nomes = ['Normal', 'Grande', 'Muito grande', 'Extra grande', 'Máximo'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Configurações'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Tela de chamada ──────────────────────────────
            Text('Tela de chamada', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDefaultDialer == true
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                    color: _isDefaultDialer == true
                        ? AppColors.green
                        : AppColors.amber,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isDefaultDialer == true
                          ? 'Tela simplificada ativa. O Elvira mostra só Viva-voz e Encerrar durante as ligações.'
                          : 'Para usar a tela simplificada de chamadas, defina o Elvira como app de telefone padrão.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            if (_isDefaultDialer == false) ...[
              const SizedBox(height: 12),
              ElviraButton(
                label: 'Definir como telefone padrão',
                onPressed: () async {
                  await CallService.instance.requestDefaultDialer();
                  await Future.delayed(const Duration(milliseconds: 800));
                  await _checkDefaultDialer();
                },
              ),
            ],
            const SizedBox(height: 28),
            // ─── Som do Alarme ────────────────────────────────
            Text('Som do alarme de remédio', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Column(
                children: PrefsService.sonsDisponiveis.map((som) {
                  final selecionado = _somAtual?.id == som.id;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _salvarSom(som),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: selecionado ? AppColors.blueXLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: som.id,
                            groupValue: _somAtual?.id,
                            activeColor: AppColors.primary,
                            onChanged: (v) => _salvarSom(som),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(som.nome, style: AppTextStyles.body),
                                if (selecionado)
                                  Text('Toque para ouvir preview', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          if (selecionado)
                            const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),
            // ─── Volume do Celular ────────────────────────────
            Text('Volume do celular', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.hearing_rounded, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Volume mínimo salvo: ${(_volumeCalibracao * 100).round()}%',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElviraButton(
              label: 'Calibrar volume',
              onPressed: _mostrarDialogoCalibracao,
            ),
            const SizedBox(height: 28),
            // Tamanho de fonte
            Text('Tamanho do texto', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.blueLight)),
              child: Column(
                children: [
                  Text(
                    'Texto de exemplo',
                    style: TextStyle(fontSize: 18 * _escala, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    textScaler: TextScaler.noScaling,
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: escalas.indexOf(_escala).toDouble(),
                    min: 0,
                    max: (escalas.length - 1).toDouble(),
                    divisions: escalas.length - 1,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _escala = escalas[v.round()]),
                  ),
                  Text(nomes[escalas.indexOf(_escala)], style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElviraButton(label: 'Aplicar tamanho', onPressed: _salvarEscala),
            const SizedBox(height: 28),
            // Trocar PIN
            Text('Trocar PIN do cuidador', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.blueLight)),
              child: Column(
                children: [
                  _pinField('PIN atual', _pinAtualCtrl),
                  const SizedBox(height: 10),
                  _pinField('Novo PIN (4 dígitos)', _pinNovoCtrl),
                  const SizedBox(height: 10),
                  _pinField('Confirmar novo PIN', _pinConfCtrl),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElviraButton(label: 'Trocar PIN', onPressed: _trocarPin),
            const SizedBox(height: 40),
            // ─── Resetar app ──────────────────────────────────
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Text('Zona de perigo', style: AppTextStyles.h3.copyWith(color: AppColors.red)),
            const SizedBox(height: 8),
            Text(
              'Apaga todos os dados e reinicia a configuração do zero.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _resetarApp,
                icon: const Icon(Icons.warning_amber_rounded, size: 24),
                label: const Text(
                  'Resetar aplicativo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _pinField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      maxLength: 4,
      obscureText: true,
      style: AppTextStyles.body,
      decoration: InputDecoration(labelText: label, counterText: ''),
    );
  }
}
