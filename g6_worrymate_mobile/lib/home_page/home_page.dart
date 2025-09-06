import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

import '../core/localization/locales.dart';
import '../core/theme/theme_manager.dart';
import '../core/widgets/custom_bottom_nav_bar.dart';
import '../features/activity_tracking/presentation/cubit/activity_cubit.dart';
import '../features/activity_tracking/presentation/cubit/activity_state.dart';
// Page section + widget imports
import 'data.dart';
import 'widgets/activity_ring.dart';
import 'widgets/ai_prompt_section.dart';
import 'widgets/daily_affirmation_card.dart';
import 'widgets/greetings.dart';
import 'widgets/module_header.dart';
import 'widgets/mood_checkin_card.dart';
import 'widgets/progress_row.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/safety_banner.dart';
import 'widgets/streak_bar.dart';
import 'widgets/top_bar.dart';
import 'widgets/weekly_bar_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Device
  late double _deviceHeight;
  late double _deviceWidth;

  // Hero (module) carousel
  late final PageController _heroPageController;
  Timer? _heroSlideTimer;
  final Duration _heroSlideInterval = const Duration(seconds: 5);
  final Duration _heroSlideAnimDuration = const Duration(milliseconds: 600);
  final Curve _heroSlideCurve = Curves.easeInOut;
  late final List<ImageProvider> _heroImages;
  int _selectedModule = 0;

  // Tabs
  int _currentTab = 0;

  // Prompt / AI
  final TextEditingController _promptCtrl = TextEditingController();
  final List<String> _quickPromptKeys = [
    LocalData.homePromptFeelingAnxious,
    LocalData.homePromptImproveSleep,
    LocalData.homePromptLowMotivation,
    LocalData.homePromptOverthinking,
  ];

  // Affirmations
  final List<String> _affirmationKeys = [
    LocalData.homeAffirmation1,
    LocalData.homeAffirmation2,
    LocalData.homeAffirmation3,
    LocalData.homeAffirmation4,
  ];
  late final int _affirmationIndex;

  // Scroll-driven hero visibility
  late final ScrollController _contentScrollController;
  bool _showHeroBackground = true;
  static const double _heroVisibilityThreshold = 10;

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController();
    _contentScrollController = ScrollController()
      ..addListener(_onContentScroll);
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
    _contentScrollController
      ..removeListener(_onContentScroll)
      ..dispose();
    _promptCtrl.dispose();
    super.dispose();
  }

  // ========= Scroll Listener =========
  void _onContentScroll() {
    if (_currentTab != 0) return;
    final shouldShow =
        _contentScrollController.offset <= _heroVisibilityThreshold;
    if (shouldShow != _showHeroBackground) {
      setState(() => _showHeroBackground = shouldShow);
    }
  }

  // ========= Helpers =========
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

  // Safe formatting (user replaced {} with %a in templates)
  String _fmtTemplate(String raw, List<String> args) {
    if (args.isEmpty) return raw;
    if (raw.contains('%a')) {
      var out = raw;
      for (final a in args) {
        out = out.replaceFirst('%a', a);
      }
      return out;
    }
    // Fallback if {} is used
    return context.formatString(raw, args);
  }

  // ========= Activity Actions =========
  void _onQuickActionSelected(String id) {
    context.read<ActivityCubit>().logActivity(id);
    final template = LocalData.homeActivityLoggedTemplate.getString(context);
    final msg = _fmtTemplate(template, [id]);
    _showSnack(msg);
    _navigateToQuickAction(id);
  }

  void _navigateToQuickAction(String id) {
    switch (id) {
      case 'journal':
        Navigator.pushNamed(context, '/journal');
        break;
      case 'breathing':
        Navigator.pushNamed(context, '/box_breathing');
        break;
      case 'trackWins':
        Navigator.pushNamed(context, '/win_tracker');
        break;
      case 'chatAI':
        Navigator.pushNamed(context, '/chat');
        break;
      default:
        _showSnack('Unknown action: $id');
    }
  }

  void _onMoodSelected(String moodLabel) {
    context.read<ActivityCubit>().logMood(moodLabel);
    final template = LocalData.homeMoodLoggedTemplate.getString(context);
    final msg = _fmtTemplate(template, [moodLabel]);
    _showSnack(msg);
  }

  void _submitPrompt() {
    final text = _promptCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ActivityCubit>().logActivity('chatAI');
    Future.microtask(() {
      if (!mounted) return;
      Navigator.pushNamed(context, '/chat', arguments: text);
    });
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        content: Text(msg),
      ),
    );
  }

  // ========= Page Switching =========
  Widget _pageFor(int index) {
    switch (index) {
      case 0:
        return _contentLayer();
      case 1:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/journal');
          }
        });
        return const SizedBox.shrink();
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/offlinetoolkit');
          }
        });
        return const SizedBox.shrink();

      case 3:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/chat');
          }
        });
        return const SizedBox.shrink();
      case 4:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        });
        return const SizedBox.shrink();
      default:
        return _contentLayer();
    }
  }

  // ========= Build =========
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    final bool baseHeroCondition = _currentTab == 0;
    final bool effectiveShowHero = baseHeroCondition && _showHeroBackground;

    Color getBackgroundColor() =>
        isDarkMode ? const Color.fromARGB(255, 9, 43, 71) : Colors.white;

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      body: Stack(
        children: [
          if (baseHeroCondition)
            AnimatedOpacity(
              opacity: effectiveShowHero ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              child: Stack(
                children: [
                  _heroModulesBackground(isDarkMode),
                  _gradientOverlay(isDarkMode),
                ],
              ),
            ),
          Positioned.fill(child: _pageFor(_currentTab)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          if (i == _currentTab) return;
          setState(() {
            _currentTab = i;
            if (i == 0) {
              // Recompute visibility when returning to tab 0
              final shouldShow = !_contentScrollController.hasClients
                  ? true
                  : _contentScrollController.offset <= _heroVisibilityThreshold;
              _showHeroBackground = shouldShow;
            }
          });
        },
      ),
    );
  }

  // ========= Hero (background module gallery) =========
  Widget _heroModulesBackground(bool isDarkMode) {
    final count = featuredAppServices.length;
    return SizedBox(
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
            if (mounted) setState(() => _selectedModule = index);
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

  // ========= Foreground Content =========
  Widget _contentLayer() {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    return SingleChildScrollView(
      controller: _contentScrollController,
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
            SizedBox(height: _deviceHeight * 0.05),
            Greetings(isDarkMode: isDarkMode, deviceHeight: _deviceHeight),
            SizedBox(height: _deviceHeight * 0.015),
            ModuleHeader(
              isDarkMode: isDarkMode,
              selectedIndex: _selectedModule,
              titles: featuredAppServices.map((e) => e.title).toList(),
              deviceHeight: _deviceHeight,
            ),
            SizedBox(height: _deviceHeight * 0.02),

            // Progress summary
            BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is ActivityReady) {
                  final legacyMap = {
                    for (final d in state.daysByKey.values)
                      DateTime(d.date.year, d.date.month, d.date.day):
                          d.activities.length,
                  };
                  return ProgressRow(
                    isDarkMode: isDarkMode,
                    activityData: legacyMap,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
              quickPrompts: _quickPromptKeys
                  .map((k) => k.getString(context))
                  .toList(),
              onSubmit: _submitPrompt,
            ),
            SizedBox(height: _deviceHeight * 0.02),

            SafetyBanner(
              isDarkMode: isDarkMode,
              deviceHeight: _deviceHeight,
              deviceWidth: _deviceWidth,
              image:
                  (featuredAppServices[(featuredAppServices.length > 2 ? 2 : 0)]
                      .coverImage
                      .url
                      .isNotEmpty)
                  ? AssetImage(
                      featuredAppServices[(featuredAppServices.length > 2
                              ? 2
                              : 0)]
                          .coverImage
                          .url,
                    )
                  : const AssetImage('assets/images/placeholder.png'),
              text: LocalData.homeSafetyBannerText.getString(context),
              onTap: () {
                Navigator.pushNamed(context, '/crisis_action');
              },
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

            BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is! ActivityReady) {
                  return const SizedBox.shrink();
                }
                final activityData = {
                  for (final d in state.daysByKey.values)
                    DateTime(d.date.year, d.date.month, d.date.day):
                        d.activities.length,
                };
                final todayCount = state.todayCount;
                final weekTotal = state.totalLast7();
                final streak = state.streak;
                const dailyMax = ActivityCubit.dailyMax;
                final weekMax = dailyMax * ActivityCubit.windowDays;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeeklyBarChart(
                      isDarkMode: isDarkMode,
                      activityData: activityData,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActivityRing(
                          label: LocalData.homeRingToday.getString(context),
                          percent: (todayCount / dailyMax).clamp(0, 1),
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
                          percent: (streak / 30).clamp(0, 1),
                          centerText: '${streak}d',
                          color: isDarkMode
                              ? Colors.lightBlueAccent
                              : Colors.lightBlue,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StreakBar(
                      isDarkMode: isDarkMode,
                      streak: streak,
                      label: _fmtTemplate(
                        LocalData.homeStreakBarTemplate.getString(context),
                        [streak.toString()],
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: _deviceHeight * 0.04),

            // ScrollableServicesWidget(
            //   height: _deviceHeight * 0.24,
            //   width: _deviceWidth,
            //   showTitle: true,
            //   isDark: isDarkMode,
            //   servicesData: offlineTools,
            //   onServiceTap: (service) {
            //     final route = _routeForServiceTitle(service.title);
            //     Navigator.pushNamed(context, route);
            //   },
            // ),
            // SizedBox(height: _deviceHeight * 0.04),
          ],
        ),
      ),
    );
  }

  String _routeForServiceTitle(String title) {
    switch (title.trim().toLowerCase()) {
      case 'breathing timer':
        return '/box_breathing';
      case 'grounding 5-4-3-2-1':
        return '/five_four';
      case 'win tracker':
        return '/win_tracker';
      case 'journal':
        return '/journal';
      default:
        return '/';
    }
  }
}
