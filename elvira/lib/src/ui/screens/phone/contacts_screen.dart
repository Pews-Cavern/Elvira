import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  final double minFontSize = 20;

  final List<Map<String, String>> favoriteContacts = const [
    {'name': 'Maria', 'number': '+55 41 98888-0001'},
    {'name': 'João', 'number': '+55 41 97777-0002'},
  ];

  final List<Map<String, String>> allContacts = const [
    {'name': 'Carlos Silva', 'number': '+55 41 91234-0003'},
    {'name': 'Fernanda Oliveira', 'number': '+55 41 96543-0004'},
    {'name': 'Lucas Andrade', 'number': '+55 41 99876-0005'},
  ];

  void _confirmCall(BuildContext context, String name, String number) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.phone_forwarded,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ligar para\n$name?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final Uri uri = Uri(scheme: 'tel', path: number);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Não foi possível fazer a ligação',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.025,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sim',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.025,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Não',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 36),
                    color: elviraColorMap[ElviraColor.primary],
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Contatos',
                    style: TextStyle(
                      fontSize: screen.width * 0.09,
                      fontWeight: FontWeight.bold,
                      color: elviraColorMap[ElviraColor.onBackground],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                children:
                    favoriteContacts.map((contact) {
                      return ElevatedButton(
                        onPressed:
                            () => _confirmCall(
                              context,
                              contact['name']!,
                              contact['number']!,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          elevation: 3,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                contact['name']!,
                                style: TextStyle(
                                  fontSize: screen.width * 0.06,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: allContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final contact = allContacts[index];
                    return InkWell(
                      onTap:
                          () => _confirmCall(
                            context,
                            contact['name']!,
                            contact['number']!,
                          ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 240, 240),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_circle,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  contact['name']!,
                                  style: TextStyle(
                                    fontSize:
                                        screen.width * 0.06 < minFontSize
                                            ? minFontSize
                                            : screen.width * 0.06,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
