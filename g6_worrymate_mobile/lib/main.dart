import 'package:flutter/material.dart';

import 'features/action_card/presentation/screens/action_card_screen.dart';
import 'features/action_card/presentation/screens/chat_screen.dart';
import 'features/action_card/presentation/screens/offline_toolkit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/action_card': (context) => const ActionCardScreen(),
        '/': (context) => ChatScreen(),
        '/offline-tool': (context) => const OfflineToolkitScreen(),
      },
    );
  }
}
