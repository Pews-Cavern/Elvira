// contact_management_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:elvira/src/ui/widgets/buttons/elvira_button.dart';
import 'package:elvira/src/ui/widgets/elvira_modal.dart';

class ContactManagementScreen extends StatefulWidget {
  const ContactManagementScreen({super.key});

  @override
  State<ContactManagementScreen> createState() => _ContactManagementScreenState();
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  final double confirmDuration = 5;

  List<Map<String, String>> contatos = [
    {'name': 'Maria', 'number': '+55 41 98888-0001'},
    {'name': 'João', 'number': '+55 41 97777-0002'},
    {'name': 'Carlos', 'number': '+55 41 98888-0003'},
  ];

  double _holdSeconds = 0;
  Timer? _holdTimer;
  String? _selectedName;
  int? _selectedIndex;

  void _startHold(Function onComplete) {
    _holdSeconds = confirmDuration;
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _holdSeconds--);
      if (_holdSeconds <= 0) {
        _holdTimer?.cancel();
        onComplete();
        Navigator.pop(context);
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    setState(() => _holdSeconds = confirmDuration);
  }

  void _showAddContact() {
    String name = '';
    String number = '';

    showDialog(
      context: context,
      builder: (context) => ElviraModal(
        title: 'Adicionar Contato',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nome'),
              onChanged: (val) => name = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Número'),
              keyboardType: TextInputType.phone,
              onChanged: (val) => number = val,
            ),
          ],
        ),
        actions: [
          ElviraButton(
            label: 'Salvar',
            onPressed: () {
              setState(() => contatos.add({'name': name, 'number': number}));
              Navigator.pop(context);
            },
            color: ElviraColor.success,
          ),
          const SizedBox(height: 15),
          ElviraButton(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context),
            color: ElviraColor.warning,
          ),
        ],
      ),
    );
  }

  void _showEditContact(int index) {
    String name = contatos[index]['name']!;
    String number = contatos[index]['number']!;

    final nameController = TextEditingController(text: name);
    final numberController = TextEditingController(text: number);

    showDialog(
      context: context,
      builder: (context) => ElviraModal(
        title: 'Editar Contato',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              onChanged: (val) => name = val,
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Número'),
              keyboardType: TextInputType.phone,
              onChanged: (val) => number = val,
            ),
          ],
        ),
        actions: [
          ElviraButton(
            label: 'Salvar',
            onPressed: () {
              setState(() => contatos[index] = {'name': name, 'number': number});
              Navigator.pop(context);
            },
            color: ElviraColor.success,
          ),
          const SizedBox(height: 15),
          ElviraButton(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context),
            color: ElviraColor.warning,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(int index) {
    _selectedIndex = index;
    _selectedName = contatos[index]['name'];
    _holdSeconds = confirmDuration;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => ElviraModal(
          title: 'Confirmar Exclusão',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aperte e segure para excluir ${_selectedName ?? 'o contato'}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onLongPressStart: (_) {
                  _startHold(() => setState(() => contatos.removeAt(index)));
                  setModalState(() {});
                },
                onLongPressEnd: (_) {
                  _cancelHold();
                  setModalState(() {});
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElviraButton(
                    label: 'Segure para confirmar',
                    onPressed: () {},
                    color: ElviraColor.error,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            const SizedBox(height: 15),
            ElviraButton(
              label: 'Cancelar',
              onPressed: () => Navigator.pop(context),
              color: ElviraColor.warning,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: elviraColorMap[ElviraColor.background],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 36),
                    color: elviraColorMap[ElviraColor.success],
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Configurar Contatos',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: screen.width * 0.09,
                          fontWeight: FontWeight.bold,
                          color: elviraColorMap[ElviraColor.onBackground],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: contatos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final contato = contatos[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, size: 48, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              contato['name']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditContact(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirm(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElviraButton(
                  label: 'Adicionar Contato',
                  onPressed: _showAddContact,
                  color: ElviraColor.success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
