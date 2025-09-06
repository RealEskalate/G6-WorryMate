import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locales.dart';
import 'core/theme/theme_manager.dart';
import 'features/action_card/presentation/bloc/chat_bloc.dart';
import 'features/action_card/presentation/screens/chat_screen.dart';
import 'features/activity_tracking/presentation/cubit/activity_cubit.dart';
import 'features/crisis_card/presentation/pages/crisis_card.dart';
import 'features/offline_toolkit/presentation/pages/box_breathing_screen.dart';
import 'features/offline_toolkit/presentation/pages/daily_journal_screen.dart';
import 'features/offline_toolkit/presentation/pages/five_four_screen.dart';
import 'features/offline_toolkit/presentation/pages/offline_toolkit_screen.dart';
import 'features/offline_toolkit/presentation/pages/win_tracker_screen.dart';
import 'features/reminder/presentation/cubit/reminder_cubit.dart';
import 'features/reminder/presentation/pages/reminder_page.dart';
import 'features/reminder/services/notification_service.dart';
import 'features/setting/settings.dart';
import 'home_page/home_page.dart';
import 'injection_container.dart';
import 'onbording/first_install_page.dart';
import 'onbording/first_page.dart';
import 'onbording/get_started_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  await init();
  await Hive.openBox('journalBox');
  await sl<NotificationService>().init();

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}


class MyApp extends StatefulWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: 'am');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<ActivityCubit>()..load()),
      BlocProvider(create: (_) => sl<ReminderCubit>()),
      ],
      child: ChangeNotifierProvider(
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
              supportedLocales: localization.supportedLocales,
              localizationsDelegates: localization.localizationsDelegates,
              initialRoute: widget.isFirstLaunch ? '/first' : '/firstpage',
              routes: {
                '/first': (context) => const OnboardingPage(), // splash/first page
                '/firstpage': (context) => const SplashScreen(), // splash/first page
                '/onboarding_last': (context) => const OnboardingScreen(), // last onboarding page
                // '/action_card': (context) => const ActionCardWidget(),

                '/': (context) => const HomePage(),
                '/chat': (_) => BlocProvider(
                  create: (_) => sl<ChatBloc>(),
                  child: ChatScreen(),
                ),
                '/settings': (context) => BlocProvider(
                      create: (_) => sl<ChatBloc>(),
                      child: const SettingsPage(),
                    ),
                '/offlinetoolkit': (context) => const OfflineToolkitScreen(),
                '/journal': (context) => const DailyJournalScreen(),
                '/crisis_action': (context) => const CrisisCard(),
                '/win_tracker': (context) => const WinTrackerScreen(),
                '/box_breathing': (context) => const BoxBreathingScreen(),
                '/five_four': (context) => const FiveFourScreen(),


                // '/notification': (context) => const ReminderPage()
              },
            );
          },
        ),
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
