import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_text_styles.dart';

class MemorialScreen extends StatefulWidget {
  const MemorialScreen({super.key});

  @override
  State<MemorialScreen> createState() => _MemorialScreenState();
}

class _MemorialScreenState extends State<MemorialScreen> {
  final _controller = PageController();
  int _pagina = 0;

  static const _fundo = Color(0xFF0D1B2A);
  static const _fundoCard = Color(0xFF162232);

  static const _slides = [
    _Slide(
      foto: 'assets/images/vida_real/Elvira_&_Nelson.png',
      legenda: "Domingas \"Elvira\" Fiorese Geronasso\ne seu Nelson Geronasso",
      data: "28/10/2014",
    ),
    _Slide(
      foto: 'assets/images/vida_real/Elvira_&_Nelson_&_Paulo_Eduardo.png',
      legenda: "Domingas \"Elvira\" Fiorese Geronasso,\nNelson Geronasso e Paulo Eduardo Konopka",
      data: "04/06/2009",
    ),
    _Slide(
      foto: 'assets/images/vida_real/Elvira_Na_Chacara.png',
      legenda: "Domingas \"Elvira\" Fiorese Geronasso\nna Chácara",
    ),
    _Slide(
      foto: 'assets/images/vida_real/Elvira_&_Maria_Eduarda.png',
      legenda: "Elvira e Maria Eduarda",
    ),
    _Slide(
      icone: '🕊️',
      texto: "Dona Elvira faleceu em 05/06/2019,\ncom 89 anos,\napós sofrer um ataque vascular cerebral.",
    ),
    _Slide(
      icone: '🕊️',
      texto: "Seu Nelson Geronasso faleceu em 17/10/2023,\ncom 92 anos,\napós contrair uma infecção urinária.",
    ),
    _Slide(
      foto: 'assets/images/vida_real/Elvira_&_Paulo_Eduardo.png',
      legenda: "Dona Elvira e seu bisneto Paulo Eduardo Konopka",
      data: "28/11/2019",
    ),
    _Slide(
      icone: '❤️',
      texto: "Este projeto foi feito em homenagem\na ambos os meus bisavós —\nem especial à Vó Elvira,\nque passou seus últimos anos\ntentando aprender a mexer no celular comigo.\n\n— Paulo Eduardo Konopka",
    ),
    _Slide(
      icone: '🙏',
      texto: "Obrigado a todos que utilizarem este aplicativo.\nQue a memória deles\ncontinue viva em cada toque na tela.",
      encerramento: true,
    ),
  ];

  void _avancar() {
    HapticFeedback.lightImpact();
    if (_pagina < _slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_pagina];
    final ehUltimo = _pagina == _slides.length - 1;

    return Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white54, size: 28),
                    tooltip: 'Fechar',
                  ),
                  const Spacer(),
                  Text(
                    '${_pagina + 1} / ${_slides.length}',
                    style: AppTextStyles.body.copyWith(color: Colors.white38, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Conteúdo deslizável
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _pagina = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideView(slide: _slides[i], fundoCard: _fundoCard),
              ),
            ),

            // Indicadores de progresso
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final ativo = i == _pagina;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: ativo ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: ativo ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

            // Botão de avançar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _avancar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: slide.encerramento ? Colors.white : const Color(0xFF5B4BD5),
                    foregroundColor: slide.encerramento ? _fundo : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Text(
                    ehUltimo ? 'Fechar' : 'Continuar →',
                    style: AppTextStyles.button.copyWith(
                      color: slide.encerramento ? _fundo : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  final Color fundoCard;

  const _SlideView({required this.slide, required this.fundoCard});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (slide.foto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.48,
                color: fundoCard,
                child: Image.asset(
                  slide.foto!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.white30, size: 48),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: screenHeight * 0.18,
              child: Center(
                child: Text(slide.icone ?? '💛', style: const TextStyle(fontSize: 72)),
              ),
            ),

          const SizedBox(height: 28),

          // Legenda ou texto principal
          if (slide.texto != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: fundoCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                slide.texto!,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 19,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else if (slide.legenda != null) ...[
            Text(
              slide.legenda!,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (slide.data != null) ...[
              const SizedBox(height: 8),
              Text(
                slide.data!,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
              ),
            ],
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Slide {
  final String? foto;
  final String? legenda;
  final String? data;
  final String? icone;
  final String? texto;
  final bool encerramento;

  const _Slide({
    this.foto,
    this.legenda,
    this.data,
    this.icone,
    this.texto,
    this.encerramento = false,
  });
}
