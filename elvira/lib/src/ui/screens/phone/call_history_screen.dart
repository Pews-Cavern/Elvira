import 'package:flutter/material.dart';
import 'package:elvira/src/ui/theme/elvira_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final dummyCalls = [
      {
        'name': 'Maria Silva',
        'type': 'received',
        'time': 'Hoje, 14:30',
        'number': '+55 41 98888-0001',
      },
      {
        'name': 'João Pereira',
        'type': 'missed',
        'time': 'Hoje, 09:12',
        'number': '+55 41 97777-0002',
      },
      {
        'name': 'Farmácia Popular',
        'type': 'dialed',
        'time': 'Ontem, 19:20',
        'number': '+55 41 3555-1234',
      },
    ];

    Icon _getCallIcon(String type) {
      switch (type) {
        case 'received':
          return const Icon(Icons.call_received, color: Colors.green, size: 32);
        case 'missed':
          return const Icon(Icons.call_missed, color: Colors.red, size: 32);
        case 'dialed':
          return const Icon(Icons.call_made, color: Colors.blue, size: 32);
        default:
          return const Icon(Icons.phone, color: Colors.grey, size: 32);
      }
    }

    void _showCallConfirmation(
      BuildContext context,
      String name,
      String number,
    ) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_forwarded, size: 48, color: Colors.green),
                    const SizedBox(height: 20),
                    Text(
                      'Retornar chamada para\n$name?',
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
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                       
                        const SizedBox(width: 16),

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
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
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
        },
      );
    }

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
                    'Chamadas Recentes',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: elviraColorMap[ElviraColor.onBackground],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: dummyCalls.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final call = dummyCalls[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 28,
                            child: _getCallIcon(call['type']!),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  call['name']!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  call['time']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showCallConfirmation(
                                context,
                                call['name']!,
                                call['number']!,
                              );
                            },
                            icon: const Icon(
                              Icons.phone,
                              size: 32,
                              color: Colors.green,
                            ),
                          ),
                        ],
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
