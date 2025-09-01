import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/action_card/presentation/bloc/chat_bloc.dart';
import 'features/action_card/presentation/screens/action_card_screen.dart';
import 'features/action_card/presentation/screens/chat_screen.dart';
import 'features/offline_toolkit/presentation/pages/daily_journal_screen.dart';
import 'features/offline_toolkit/presentation/pages/offline_toolkit_screen.dart';
import 'features/setting/settings.dart';
import 'home_page/home_page.dart';
import 'injection_container.dart';

void main() {
  init();
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
        // '/action_card': (context) => const ActionCardWidget(),
        '/': (context) => const HomePage(),
        '/chat': (_) =>
            BlocProvider(create: (_) => sl<ChatBloc>(), child: ChatScreen()),
        '/settings': (context) => const SettingsPage(),
        '/offlinetoolkit': (context) => const OfflineToolkitScreen(),
        '/journal': (context) => const DailyJournalScreen(),
      },
    );
  }
}
