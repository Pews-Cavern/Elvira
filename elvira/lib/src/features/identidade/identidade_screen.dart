import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../services/call_service.dart';
import '../../core/providers/usuario_provider.dart';
import '../../core/providers/contatos_provider.dart';
import '../../core/models/usuario.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elvira_app_bar.dart';
import '../../core/widgets/contato_avatar.dart';

class IdentidadeScreen extends StatelessWidget {
  const IdentidadeScreen({super.key});

  int _calcularIdade(String? dataNasc) {
    if (dataNasc == null) return 0;
    try {
      final nasc = DateTime.parse(dataNasc);
      final hoje = DateTime.now();
      int idade = hoje.year - nasc.year;
      if (hoje.month < nasc.month || (hoje.month == nasc.month && hoje.day < nasc.day)) idade--;
      return idade;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ElviraAppBar(title: 'Minha Identidade'),
      body: Consumer2<UsuarioProvider, ContatosProvider>(
        builder: (_, usuProvider, contatosProvider, _) {
          final u = usuProvider.usuario;
          if (u == null) {
            return Center(child: Text('Nenhum dado cadastrado', style: AppTextStyles.body));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CartaoIdentidade(usuario: u, idade: _calcularIdade(u.dataNascimento)),
                const SizedBox(height: 16),
                if (u.tipoSanguineo != null || u.alergias != null)
                  _SaudePainel(usuario: u),
                const SizedBox(height: 16),
                if (u.condicoesSaude != null)
                  _InfoCard(
                    titulo: 'CONDIÇÕES',
                    icon: '💊',
                    conteudo: u.condicoesSaude!,
                  ),
                const SizedBox(height: 16),
                _EmergenciaContatos(contatos: contatosProvider.emergencia),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartaoIdentidade extends StatelessWidget {
  final Usuario usuario;
  final int idade;
  const _CartaoIdentidade({required this.usuario, required this.idade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueLight, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.blueLight,
            child: const Icon(Icons.person, size: 48, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(usuario.nome, style: AppTextStyles.idName),
                if (idade > 0)
                  Text('$idade anos', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                if (usuario.genero != 'nao_informado')
                  Text(
                    usuario.genero == 'feminino' ? 'Feminino' : 'Masculino',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaudePainel extends StatelessWidget {
  final Usuario usuario;
  const _SaudePainel({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (usuario.tipoSanguineo != null)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Tipo Sanguíneo', style: AppTextStyles.idLabel),
                  const SizedBox(height: 4),
                  Text(usuario.tipoSanguineo!, style: AppTextStyles.idBloodType),
                ],
              ),
            ),
          ),
        if (usuario.tipoSanguineo != null && usuario.alergias != null)
          const SizedBox(width: 12),
        if (usuario.alergias != null)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.redMedium,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Alergias', style: AppTextStyles.idLabel),
                  const SizedBox(height: 4),
                  Text(usuario.alergias!, style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String icon;
  final String conteudo;
  const _InfoCard({required this.titulo, required this.icon, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(conteudo, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergenciaContatos extends StatelessWidget {
  final List contatos;
  const _EmergenciaContatos({required this.contatos});

  @override
  Widget build(BuildContext context) {
    if (contatos.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.redMedium, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠️ CONTATOS DE EMERGÊNCIA',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.red, letterSpacing: 1, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...contatos.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ContatoAvatar(contato: c, radius: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.nome, style: AppTextStyles.bodyBold),
                          Text(c.telefone, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        await CallService.instance.setCallerInfo(c.nome, c.telefone);
                        await FlutterPhoneDirectCaller.callNumber(c.telefone);
                      },
                      icon: const Icon(Icons.call, size: 20),
                      label: const Text('Ligar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(96, 56),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
