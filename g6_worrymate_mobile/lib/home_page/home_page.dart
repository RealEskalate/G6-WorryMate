import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:g6_worrymate_mobile/features/offline_toolkit/presentation/pages/offline_toolkit_screen.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

import '../core/localization/locales.dart';
import 'data.dart';
import 'functions/streak_calculator.dart';
import 'scrollable_services_widget.dart';
import 'widgets/greetings.dart';
import 'widgets/progress_row.dart';
import 'widgets/top_bar.dart';
import 'widgets/module_header.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/daily_affirmation_card.dart';
import 'widgets/ai_prompt_section.dart';
import 'widgets/safety_banner.dart';
import 'widgets/mood_checkin_card.dart';
import 'widgets/weekly_bar_chart.dart';
import 'widgets/activity_ring.dart';
import 'widgets/streak_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late final PageController _heroPageController;
  Timer? _heroSlideTimer;
  final Duration _heroSlideInterval = const Duration(seconds: 5);
  final Duration _heroSlideAnimDuration = const Duration(milliseconds: 600);
  final Curve _heroSlideCurve = Curves.easeInOut;
  late final List<ImageProvider> _heroImages;

  int _selectedModule = 0;
  int _currentTab = 0;

  final TextEditingController _promptCtrl = TextEditingController();

  // ================= UNIQUE ACTIVITY TRACKING =================
  // Public-facing map still used by charts and progress UI.
  final Map<DateTime, int> _activityData = {};

  // Internal per-day unique activity sets.
  final Map<DateTime, Set<String>> _dailyActivitySets = {};

  // Universe of trackable daily unique activities (add more ids as needed).
  static const List<String> _kActivityIds = [
    'journal',
    'breathing',
    'trackWins',
    'chatAI',
    'moodCheckIn',
  ];

  int get _kMaxDailyActivity => _kActivityIds.length;
  static const int _kVisualMaxStreak = 30; // for ring normalization

  DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Records an activity only if it hasn't been done yet today.
  /// Returns true if this call added a NEW unique activity (and updated UI).
  bool _recordActivity(String activityId, {DateTime? when}) {
    if (!_kActivityIds.contains(activityId)) {
      // Optionally ignore or add dynamically. For now we ignore unknown IDs.
      return false;
    }
    final ts = when ?? DateTime.now();
    final key = _dayKey(ts);
    final set = _dailyActivitySets.putIfAbsent(key, () => <String>{});
    final before = set.length;
    set.add(activityId);
    if (set.length != before) {
      _activityData[key] = set.length.clamp(0, _kMaxDailyActivity);
      setState(() {});
      return true;
    }
    return false;
  }

  void _onQuickActionSelected(String id) {
    final added = _recordActivity(id);
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.formatString(LocalData.homeActivityLoggedTemplate, [id]),
          ),
          duration: const Duration(milliseconds: 900),
        ),
      );
    }
  }

  void _onMoodSelected(String moodLabel) {
    final added = _recordActivity('moodCheckIn');
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.formatString(LocalData.homeMoodLoggedTemplate, [moodLabel]),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // ================= AFFIRMATIONS & PROMPTS =================
  final List<String> _affirmationKeys = [
    LocalData.homeAffirmation1,
    LocalData.homeAffirmation2,
    LocalData.homeAffirmation3,
    LocalData.homeAffirmation4,
  ];
  late final int _affirmationIndex;

  final List<String> _quickPromptKeys = [
    LocalData.homePromptFeelingAnxious,
    LocalData.homePromptImproveSleep,
    LocalData.homePromptLowMotivation,
    LocalData.homePromptOverthinking,
  ];

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController();
    _heroImages = featuredAppServices
        .map(
          (m) => (m.coverImage.url.isNotEmpty)
              ? AssetImage(m.coverImage.url)
              : const AssetImage('assets/images/placeholder.png'),
        )
        .toList();
    _affirmationIndex = _affirmationKeys.isNotEmpty
        ? Random().nextInt(_affirmationKeys.length)
        : 0;
    _startHeroAutoSlide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final img in _heroImages) {
      precacheImage(img, context);
    }
  }

  @override
  void dispose() {
    _heroSlideTimer?.cancel();
    _heroPageController.dispose();
    _promptCtrl.dispose();
    super.dispose();
  }

  void _startHeroAutoSlide() {
    _heroSlideTimer?.cancel();
    _heroSlideTimer = Timer.periodic(_heroSlideInterval, (_) {
      if (!mounted) return;
      final count = featuredAppServices.length;
      if (count <= 1) return;
      final next = (_selectedModule + 1) % count;
      _heroPageController.animateToPage(
        next,
        duration: _heroSlideAnimDuration,
        curve: _heroSlideCurve,
      );
    });
  }

  Widget _pageFor(int index) {
    switch (index) {
      case 0:
        return _contentLayer();
      case 1:
        return _stubPage(LocalData.homeStubJournal.getString(context));
      case 2:
        return _stubPage(LocalData.homeStubWins.getString(context));
      case 3:
        _heroSlideTimer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ModalRoute.of(context)?.settings.name != '/chat') {
            Navigator.of(context).pushNamed('/chat');
          }
        });
        return Container();
      case 4:
        return _stubPage(LocalData.homeStubProfile.getString(context));
      default:
        return _contentLayer();
    }
  }

  Widget _stubPage(String label) => Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    final bool showHero = _currentTab == 0;

    Color getBackgroundColor() =>
        isDarkMode ? const Color.fromARGB(255, 9, 43, 71) : Colors.white;

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      body: Stack(
        children: [
          if (showHero) _heroModulesBackground(isDarkMode),
            if (showHero) _gradientOverlay(isDarkMode),
          Positioned.fill(child: _pageFor(_currentTab)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          if (i == _currentTab) return;
          switch (i) {
            case 0:
              setState(() => _currentTab = 0);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfflineToolkitScreen(),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  // ================= HERO BACKGROUND =================

  Widget _heroModulesBackground(bool isDarkMode) {
    final count = featuredAppServices.length;
    return RepaintBoundary(
      child: SizedBox(
        height: _deviceHeight * 0.5,
        width: _deviceWidth,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (n) {
            if (n.direction != ScrollDirection.idle) {
              _heroSlideTimer?.cancel();
            } else {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) _startHeroAutoSlide();
              });
            }
            return false;
          },
          child: PageView.builder(
            controller: _heroPageController,
            itemCount: count,
            onPageChanged: (index) {
              if (mounted) {
                setState(() => _selectedModule = index);
              }
            },
            itemBuilder: (_, i) {
              final img = _heroImages[i];
              return DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: img,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(isDarkMode ? 0.45 : 0.25),
                      BlendMode.darken,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _gradientOverlay(bool isDarkMode) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 0.85 * _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color.fromARGB(255, 9, 43, 71), Colors.transparent]
                : [Colors.white, Colors.transparent],
            stops: const [0.65, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  // ================= FOREGROUND CONTENT =================

  Widget _contentLayer() {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.05,
          vertical: _deviceHeight * 0.005,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(
              deviceHeight: _deviceHeight,
              deviceWidth: _deviceWidth,
              isDarkMode: isDarkMode,
              context: context,
            ),
            SizedBox(height: _deviceHeight * 0.02),
            Greetings(isDarkMode: isDarkMode, deviceHeight: _deviceHeight),
            SizedBox(height: _deviceHeight * 0.02),
            ModuleHeader(
              isDarkMode: isDarkMode,
              selectedIndex: _selectedModule,
              titles: featuredAppServices.map((e) => e.title).toList(),
              deviceHeight: _deviceHeight,
            ),
            SizedBox(height: _deviceHeight * 0.02),
            // ProgressRow can still derive from _activityData (unique counts).
            ProgressRow(isDarkMode: isDarkMode, activityData: _activityData),
            SizedBox(height: _deviceHeight * 0.02),
            QuickActionsRow(
              isDarkMode: isDarkMode,
              deviceHeight: _deviceHeight,
              deviceWidth: _deviceWidth,
              onActionTap: _onQuickActionSelected,
            ),
            SizedBox(height: _deviceHeight * 0.02),
            DailyAffirmationCard(
              isDarkMode: isDarkMode,
              affirmation: _affirmationKeys[_affirmationIndex].getString(
                context,
              ),
            ),
            SizedBox(height: _deviceHeight * 0.02),
            AiPromptSection(
              isDarkMode: isDarkMode,
              deviceHeight: _deviceHeight,
              controller: _promptCtrl,
              quickPrompts:
                  _quickPromptKeys.map((k) => k.getString(context)).toList(),
              onSubmit: _submitPrompt,
            ),
            SizedBox(height: _deviceHeight * 0.02),
            SafetyBanner(
              isDarkMode: isDarkMode,
              deviceHeight: _deviceHeight,
              deviceWidth: _deviceWidth,
              image: (featuredAppServices[
                          (featuredAppServices.length > 2 ? 2 : 0)]
                      .coverImage
                      .url
                      .isNotEmpty)
                  ? AssetImage(
                      featuredAppServices[
                              (featuredAppServices.length > 2 ? 2 : 0)]
                          .coverImage
                          .url,
                    )
                  : const AssetImage('assets/images/placeholder.png'),
              text: LocalData.homeSafetyBannerText.getString(context),
              onTap: () {},
            ),
            SizedBox(height: _deviceHeight * 0.025),
            MoodCheckInCard(
              isDarkMode: isDarkMode,
              deviceHeight: _deviceHeight,
              onMoodSelected: _onMoodSelected,
            ),
            SizedBox(height: _deviceHeight * 0.02),
            Text(
              LocalData.homeActivityTitle.getString(context),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: _deviceHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            WeeklyBarChart(
              isDarkMode: isDarkMode,
              activityData: _activityData,
              // If WeeklyBarChart supports a max param, pass _kMaxDailyActivity.
              // maxPerDay: _kMaxDailyActivity,
            ),
            const SizedBox(height: 14),
            _activityRingsRow(isDarkMode),
            const SizedBox(height: 8),
            StreakBar(
              isDarkMode: isDarkMode,
              streak: computeStreak(_activityData),
              label: context.formatString(
                LocalData.homeStreakBarTemplate,
                [computeStreak(_activityData).toString()],
              ),
            ),
            SizedBox(height: _deviceHeight * 0.04),
            ScrollableServicesWidget(
              height: _deviceHeight * 0.24,
              width: _deviceWidth,
              showTitle: true,
              servicesData: offlineTools,
            ),
            SizedBox(height: _deviceHeight * 0.04),
          ],
        ),
      ),
    );
  }

  void _submitPrompt() {
    final text = _promptCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _promptCtrl.clear();
    });
    _recordActivity('chatAI');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalData.homePromptSent.getString(context)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ================= ACTIVITY TRACKER (RINGS) =================

  Widget _activityRingsRow(bool isDarkMode) {
    final todayKey = _dayKey(DateTime.now());
    final todayCount = (_activityData[todayKey] ?? 0).clamp(0, _kMaxDailyActivity);

    // Sum last 7 days (including today)
    final now = DateTime.now();
    final weekTotal = _activityData.entries
        .where((e) => now.difference(e.key).inDays < 7)
        .fold<int>(0, (sum, e) => sum + e.value);

    final streak = computeStreak(_activityData);

    final weekMax = 7 * _kMaxDailyActivity;
    final streakNormMax = _kVisualMaxStreak.toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActivityRing(
          label: LocalData.homeRingToday.getString(context),
          percent: todayCount / _kMaxDailyActivity,
          centerText: '$todayCount',
          color: isDarkMode
              ? Colors.greenAccent
              : const Color.fromARGB(255, 9, 43, 71),
          isDarkMode: isDarkMode,
        ),
        ActivityRing(
          label: LocalData.homeRing7Days.getString(context),
          percent: (weekTotal / weekMax).clamp(0, 1),
          centerText: '$weekTotal',
          color: isDarkMode ? Colors.tealAccent : Colors.teal,
          isDarkMode: isDarkMode,
        ),
        ActivityRing(
          label: LocalData.homeRingStreak.getString(context),
          percent: (streak / streakNormMax).clamp(0, 1),
          centerText: '${streak}d',
          color: isDarkMode ? Colors.lightBlueAccent : Colors.lightBlue,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}