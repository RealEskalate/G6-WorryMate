import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_manager.dart';
import 'features/action_card/presentation/bloc/chat_bloc.dart';
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
    return ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WorryMate',
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeManager.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/',
            routes: {
              // '/action_card': (context) => const ActionCardWidget(),
              '/': (context) => const HomePage(),
              '/chat': (_) => BlocProvider(
                create: (_) => sl<ChatBloc>(),
                child: ChatScreen(),
              ),
              '/settings': (context) => const SettingsPage(),
              '/offlinetoolkit': (context) => const OfflineToolkitScreen(),
              '/journal': (context) => const DailyJournalScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 9, 43, 71),
        // something is removed here
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 9, 43, 71),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 9, 43, 71),
        elevation: 0,
      ),
    );
  }
}
