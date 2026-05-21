import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/providers/contatos_provider.dart';
import '../../../core/models/contato.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/elvira_app_bar.dart';
import '../../../core/widgets/elvira_button.dart';

class ContatoFormScreen extends StatefulWidget {
  const ContatoFormScreen({super.key});

  @override
  State<ContatoFormScreen> createState() => _ContatoFormScreenState();
}

class _ContatoFormScreenState extends State<ContatoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  String _relacao = '';
  bool _ehEmergencia = false;
  bool _ehFavorito = false;
  String? _fotoPath;
  Contato? _editando;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editando == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Contato) {
        _editando = args;
        _nomeCtrl.text = args.nome;
        _telefoneCtrl.text = args.telefone;
        _relacao = args.relacao;
        _ehEmergencia = args.ehEmergencia;
        _ehFavorito = args.ehFavorito;
        _fotoPath = args.fotoPath;
      }
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _telefoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _importarAgenda() async {
    final granted = await fc.FlutterContacts.requestPermission();
    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de contatos negada.')),
        );
      }
      return;
    }
    
    final contatoAgenda = await fc.FlutterContacts.openExternalPick();
    if (contatoAgenda != null) {
      final fullContact = await fc.FlutterContacts.getContact(contatoAgenda.id);
      if (fullContact != null) {
        setState(() {
          _nomeCtrl.text = fullContact.displayName;
          if (fullContact.phones.isNotEmpty) {
            _telefoneCtrl.text = fullContact.phones.first.number;
          }
        });
        if (fullContact.photo != null && fullContact.photo!.isNotEmpty) {
          final dir = await getApplicationDocumentsDirectory();
          final photoFile = File(p.join(dir.path, 'contato_${DateTime.now().millisecondsSinceEpoch}.png'));
          await photoFile.writeAsBytes(fullContact.photo!);
          setState(() {
            _fotoPath = photoFile.path;
          });
        }
      }
    }
  }

  Future<void> _escolherFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    final contato = Contato(
      id: _editando?.id,
      nome: _nomeCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim(),
      relacao: _relacao,
      ehEmergencia: _ehEmergencia,
      ehFavorito: _ehFavorito,
      fotoPath: _fotoPath,
      ordemExibicao: _editando?.ordemExibicao ?? 0,
    );
    final provider = context.read<ContatosProvider>();
    if (_editando != null) {
      await provider.atualizar(contato);
    } else {
      await provider.adicionar(contato);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ElviraAppBar(title: _editando != null ? 'Editar Contato' : 'Novo Contato'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _escolherFoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.blueLight,
                    backgroundImage: (_fotoPath != null && File(_fotoPath!).existsSync())
                        ? FileImage(File(_fotoPath!))
                        : null,
                    child: (_fotoPath == null)
                        ? const Icon(Icons.camera_alt, size: 40, color: AppColors.primary)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _importarAgenda,
                  icon: const Icon(Icons.contact_phone, color: AppColors.primary),
                  label: Text('Importar da Agenda', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nomeCtrl,
                style: AppTextStyles.body,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _telefoneCtrl,
                style: AppTextStyles.body,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone / Celular'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _relacao,
                decoration: const InputDecoration(labelText: 'Tipo de relação'),
                style: AppTextStyles.body,
                items: Contato.relacoes.map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(Contato.relacaoLabel(r)),
                )).toList(),
                onChanged: (v) => setState(() => _relacao = v!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _ehFavorito,
                onChanged: (v) => setState(() => _ehFavorito = v),
                title: Text('Contato favorito', style: AppTextStyles.body),
                subtitle: Text('Aparecerá primeiro na lista de contatos', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                activeThumbColor: Colors.amber,
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _ehEmergencia,
                onChanged: (v) => setState(() => _ehEmergencia = v),
                title: Text('Contato de emergência', style: AppTextStyles.body),
                subtitle: Text('Aparece na tela de emergência e identidade', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                activeThumbColor: AppColors.red,
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: 28),
              ElviraButton(
                label: _editando != null ? 'Salvar alterações' : 'Adicionar contato',
                onPressed: _salvando ? null : _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
