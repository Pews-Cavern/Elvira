import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/foto_service.dart';
import 'galeria_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _inicializando = true;
  bool _capturando = false;
  bool _semPermissao = false;
  bool _semCamera = false;
  File? _ultimaFoto;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inicializar();
    _carregarUltimaFoto();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      ctrl.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _inicializar();
    }
  }

  Future<void> _inicializar() async {
    setState(() { _inicializando = true; _semPermissao = false; _semCamera = false; });

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() { _semPermissao = true; _inicializando = false; });
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      setState(() { _semCamera = true; _inicializando = false; });
      return;
    }

    final ctrl = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);
    try {
      await ctrl.initialize();
    } catch (_) {
      setState(() { _semCamera = true; _inicializando = false; });
      return;
    }

    if (!mounted) { ctrl.dispose(); return; }
    setState(() { _controller = ctrl; _inicializando = false; });
  }

  Future<void> _carregarUltimaFoto() async {
    final fotos = await FotoService.listar();
    if (fotos.isNotEmpty && mounted) setState(() => _ultimaFoto = fotos.first);
  }

  Future<void> _capturar() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized || _capturando) return;
    HapticFeedback.mediumImpact();
    setState(() => _capturando = true);
    try {
      final xfile = await ctrl.takePicture();
      final salva = await FotoService.salvar(xfile.path);
      if (mounted) setState(() { _ultimaFoto = salva; _capturando = false; });
    } catch (_) {
      if (mounted) setState(() => _capturando = false);
    }
  }

  void _abrirGaleria() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const GaleriaScreen()))
        .then((_) => _carregarUltimaFoto());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildPreview(),
          _buildTopBar(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    if (_inicializando) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    if (_semPermissao) {
      return _MsgCentral(
        icon: Icons.no_photography_outlined,
        titulo: 'Permissão negada',
        subtitulo: 'Permita o acesso à câmera nas configurações do dispositivo.',
        botaoLabel: 'Abrir configurações',
        onBotao: openAppSettings,
      );
    }
    if (_semCamera || _controller == null) {
      return const _MsgCentral(
        icon: Icons.videocam_off_outlined,
        titulo: 'Câmera indisponível',
        subtitulo: 'Não foi possível acessar a câmera deste dispositivo.',
      );
    }
    return CameraPreview(_controller!);
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4,
          left: 4, right: 16, bottom: 12,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
            ),
            const Spacer(),
            const Text(
              'Câmera',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 28,
          top: 28, left: 28, right: 28,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail → galeria
            GestureDetector(
              onTap: _abrirGaleria,
              child: Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70, width: 2),
                  color: Colors.white12,
                  image: _ultimaFoto != null
                      ? DecorationImage(image: FileImage(_ultimaFoto!), fit: BoxFit.cover)
                      : null,
                ),
                child: _ultimaFoto == null
                    ? const Icon(Icons.photo_library_outlined, color: Colors.white70, size: 30)
                    : null,
              ),
            ),

            // Botão de captura
            GestureDetector(
              onTap: (_capturando || _controller == null) ? null : _capturar,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 84, height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: _capturando ? Colors.white38 : Colors.white,
                ),
                child: _capturando
                    ? const Center(
                        child: SizedBox(
                          width: 36, height: 36,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        ),
                      )
                    : null,
              ),
            ),

            // Espaço espelho
            const SizedBox(width: 68),
          ],
        ),
      ),
    );
  }
}

class _MsgCentral extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final String? botaoLabel;
  final VoidCallback? onBotao;

  const _MsgCentral({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    this.botaoLabel,
    this.onBotao,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white38, size: 72),
            const SizedBox(height: 20),
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(subtitulo, style: const TextStyle(color: Colors.white60, fontSize: 16), textAlign: TextAlign.center),
            if (botaoLabel != null) ...[
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onBotao,
                child: Text(botaoLabel!, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
