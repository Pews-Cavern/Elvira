import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../services/foto_service.dart';
import 'camera_screen.dart';

class GaleriaScreen extends StatefulWidget {
  const GaleriaScreen({super.key});

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
  List<File> _fotos = [];
  bool _carregando = true;

  static const _bg = Color(0xFF12121F);
  static const _bgCard = Color(0xFF1E1E30);

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final fotos = await FotoService.listar();
    if (mounted) setState(() { _fotos = fotos; _carregando = false; });
  }

  Future<void> _confirmarDelete(File foto) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Deletar foto?', style: TextStyle(color: Colors.white)),
        content: const Text('A foto será removida permanentemente.', style: TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Deletar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await FotoService.deletar(foto);
      _carregar();
    }
  }

  void _abrirViewer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FotoViewer(
          fotos: _fotos,
          indiceInicial: index,
          onDeletar: (f) async {
            await FotoService.deletar(f);
            _carregar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Minhas Fotos',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (_fotos.isNotEmpty)
                TextSpan(
                  text: '  ${_fotos.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 16),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CameraScreen()),
        ).then((_) => _carregar()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.camera_alt_rounded, size: 36, color: Colors.white),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _fotos.isEmpty
              ? _EstadoVazio(
                  onCamera: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CameraScreen()),
                  ).then((_) => _carregar()),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _fotos.length,
                  itemBuilder: (_, i) => _FotoTile(
                    foto: _fotos[i],
                    onTap: () => _abrirViewer(i),
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      _confirmarDelete(_fotos[i]);
                    },
                  ),
                ),
    );
  }
}

class _FotoTile extends StatelessWidget {
  final File foto;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FotoTile({required this.foto, required this.onTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: foto.path,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(foto, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  final VoidCallback onCamera;
  const _EstadoVazio({required this.onCamera});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library_outlined, color: Colors.white12, size: 96),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma foto ainda',
            style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tire sua primeira foto!',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 36),
          ElevatedButton.icon(
            onPressed: onCamera,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Abrir Câmera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Viewer ────────────────────────────────────────────────────────────────────

class _FotoViewer extends StatefulWidget {
  final List<File> fotos;
  final int indiceInicial;
  final Future<void> Function(File) onDeletar;

  const _FotoViewer({
    required this.fotos,
    required this.indiceInicial,
    required this.onDeletar,
  });

  @override
  State<_FotoViewer> createState() => _FotoViewerState();
}

class _FotoViewerState extends State<_FotoViewer> {
  late PageController _pageCtrl;
  late List<File> _fotos;
  late int _indice;
  bool _deletando = false;

  @override
  void initState() {
    super.initState();
    _fotos = List.from(widget.fotos);
    _indice = widget.indiceInicial;
    _pageCtrl = PageController(initialPage: _indice);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _deletar() async {
    setState(() => _deletando = true);
    final foto = _fotos[_indice];
    await widget.onDeletar(foto);
    if (!mounted) return;
    setState(() {
      _fotos.removeAt(_indice);
      _deletando = false;
      if (_fotos.isEmpty) { Navigator.pop(context); return; }
      if (_indice >= _fotos.length) _indice = _fotos.length - 1;
      _pageCtrl.jumpToPage(_indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${_indice + 1} de ${_fotos.length}',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          if (_deletando)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            )
          else
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
              onPressed: _deletar,
              tooltip: 'Deletar foto',
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: (i) => setState(() => _indice = i),
        itemCount: _fotos.length,
        itemBuilder: (_, i) => InteractiveViewer(
          minScale: 0.8,
          maxScale: 4.0,
          child: Hero(
            tag: _fotos[i].path,
            child: Image.file(_fotos[i], fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
