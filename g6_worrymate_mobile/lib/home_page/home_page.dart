import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:g6_worrymate_mobile/features/offline_toolkit/presentation/pages/offline_toolkit_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

import '../core/localization/locales.dart';
import 'data.dart';
import 'scrollable_services_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

enum HeatmapViewMode { month, year }

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
  final Map<DateTime, int> _activityData = {DateTime.now(): 1};

  // Affirmation keys (localized)
  final List<String> _affirmationKeys = [
    LocalData.homeAffirmation1,
    LocalData.homeAffirmation2,
    LocalData.homeAffirmation3,
    LocalData.homeAffirmation4,
  ];
  late final int _affirmationIndex;

  // Quick AI prompt keys (localized)
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

    Color getTextColor() => isDarkMode ? Colors.white : Colors.black;
    Color getSubtitleColor() => isDarkMode ? Colors.white70 : Colors.black54;
    Color getPrimaryColor() =>
        isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 9, 43, 71);
    Color getCardColor() =>
        isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey[50]!;
    Color getBorderColor() =>
        isDarkMode ? Colors.greenAccent.withOpacity(0.3) : Colors.grey[300]!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.05,
          vertical: _deviceHeight * 0.005,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _greeting(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _moduleHeader(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _progressRow(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _quickActionsRow(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _dailyAffirmationCard(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _aiPromptSection(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _safetyBanner(isDarkMode),
            SizedBox(height: _deviceHeight * 0.025),
            _moodCheckInCard(isDarkMode),
            SizedBox(height: _deviceHeight * 0.02),
            _activityTracker(isDarkMode),
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

  // ================= TOP BAR / GREETING =================

  Widget _topBar(bool isDarkMode) {
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocalData.appBrandPart1.getString(context) + ' ',
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: _deviceHeight * 0.035,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: LocalData.appBrandPart2.getString(context),
                  style: GoogleFonts.poppins(
                    color: isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71),
                    fontSize: _deviceHeight * 0.035,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.settings_rounded,
                size: 30,
                color: isDarkMode ? Colors.white : Colors.black,
                semanticLabel: 'Settings',
              ),
              SizedBox(width: _deviceWidth * 0.03),
              Icon(
                Icons.notifications,
                size: 30,
                color: isDarkMode ? Colors.white : Colors.black,
                semanticLabel: 'Notifications',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greeting(bool isDarkMode) {
    final hour = DateTime.now().hour;
    final key = hour < 12
        ? LocalData.homeGreetingMorning
        : hour < 18
            ? LocalData.homeGreetingAfternoon
            : LocalData.homeGreetingEvening;
    final text = key.getString(context);
    return Text(
      '$text 👋',
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: _deviceHeight * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ================= HERO TITLE + INDICATORS =================

  Widget _moduleHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          featuredAppServices[_selectedModule].title,
          maxLines: 2,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: _deviceHeight * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _deviceHeight * 0.008),
        Row(
          children: List.generate(featuredAppServices.length, (i) {
            final active = i == _selectedModule;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: _deviceHeight * 0.008),
              height: _deviceHeight * 0.01,
              width: active ? _deviceHeight * 0.035 : _deviceHeight * 0.015,
              decoration: BoxDecoration(
                color: active
                    ? (isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71))
                    : (isDarkMode ? Colors.white24 : Colors.grey[400]),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ================= STATS ROW =================

  Widget _progressRow(bool isDarkMode) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final weekCount =
        _activityData.keys.where((d) => now.difference(d).inDays < 7).length;
    final streak = _computeStreak();
    return Row(
      children: [
        _miniStat(
            LocalData.homeStatStreak.getString(context),
            '${streak}d',
            Icons.local_fire_department,
            isDarkMode),
        const SizedBox(width: 12),
        _miniStat(
            LocalData.homeStatThisWeek.getString(context),
            '$weekCount',
            Icons.calendar_today,
            isDarkMode),
        const SizedBox(width: 12),
        _miniStat(
          LocalData.homeStatToday.getString(context),
          '${_activityData[todayKey] ?? 0}',
          Icons.bubble_chart,
          isDarkMode,
        ),
      ],
    );
  }

  int _computeStreak() {
    final dates = _activityData.keys
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();
    int streak = 0;
    DateTime cursor = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    while (dates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Widget _miniStat(
      String label, String value, IconData icon, bool isDarkMode) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white10 : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isDarkMode
                    ? Colors.greenAccent
                    : const Color.fromARGB(255, 9, 43, 71),
                size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= QUICK ACTIONS =================

  Widget _quickActionsRow(bool isDarkMode) {
    final actions = [
      (Icons.edit_note, LocalData.homeQuickJournal.getString(context)),
      (Icons.mood, LocalData.homeQuickMood.getString(context)),
      (Icons.spa, LocalData.homeQuickBreathing.getString(context)),
      (Icons.chat_bubble, LocalData.homeQuickChatAI.getString(context)),
    ];
    return SizedBox(
      height: _deviceHeight * 0.11,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
            final icon = actions[i].$1;
            final label = actions[i].$2;
          return GestureDetector(
            onTap: () {
              if (label == LocalData.homeQuickMood.getString(context)) {
                _openMoodQuickPick(isDarkMode);
              }
            },
            child: Container(
              width: _deviceWidth * 0.23,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color.fromARGB(255, 9, 43, 71),
                          const Color(0xFF094470)]
                      : [Colors.white, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: isDarkMode ? null : Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      color: isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 9, 43, 71),
                      size: 28),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= AFFIRMATION =================

  Widget _dailyAffirmationCard(bool isDarkMode) {
    final affirmationKey = _affirmationKeys[_affirmationIndex];
    final affirmation = affirmationKey.getString(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb,
              color: isDarkMode ? Colors.amber[300] : Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              affirmation,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= AI PROMPT SECTION =================

  Widget _aiPromptSection(bool isDarkMode) {
    final prompts = _quickPromptKeys.map((k) => k.getString(context)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalData.homeAskSupportTitle.getString(context),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: _deviceHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(prompts.length, (i) {
            final p = prompts[i];
            final selected = _promptCtrl.text.trim() == p;
            return GestureDetector(
              onTap: () => setState(() => _promptCtrl.text = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDarkMode
                          ? Colors.greenAccent.withOpacity(0.25)
                          : const Color.fromARGB(255, 9, 43, 71))
                      : (isDarkMode ? Colors.white12 : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  p,
                  style: TextStyle(
                    color: selected
                        ? (isDarkMode
                            ? Colors.greenAccent
                            : const Color.fromARGB(255, 9, 43, 71))
                        : (isDarkMode ? Colors.white70 : Colors.black54),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptCtrl,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: LocalData.homePromptHint.getString(context),
                    hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white54 : Colors.grey[600]),
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 3,
                  onSubmitted: (_) => _submitPrompt(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send,
                    color: isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71)),
                onPressed: _submitPrompt,
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitPrompt() {
    final text = _promptCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _promptCtrl.clear();
      _incrementActivity(DateTime.now());
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalData.homePromptSent.getString(context)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ================= SAFETY BANNER =================

  Widget _safetyBanner(bool isDarkMode) {
    final idx = featuredAppServices.length > 2 ? 2 : 0;
    final imgProvider = (featuredAppServices[idx].coverImage.url.isNotEmpty)
        ? AssetImage(featuredAppServices[idx].coverImage.url)
        : const AssetImage('assets/images/placeholder.png');
    return Container(
      height: _deviceHeight * 0.12,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imgProvider,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(isDarkMode ? 0.55 : 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.04),
            child: Icon(
              Icons.shield_rounded,
              color: isDarkMode
                  ? Colors.greenAccent
                  : const Color.fromARGB(255, 9, 43, 71),
              size: 42,
            ),
          ),
          Expanded(
            child: Text(
              LocalData.homeSafetyBannerText.getString(context),
              style: TextStyle(
                color: Colors.white,
                fontSize: _deviceHeight * 0.02,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ================= MOOD =================

  Widget _moodCheckInCard(bool isDarkMode) {
    final moods = [
      ('😞', LocalData.homeMoodLow.getString(context)),
      ('😐', LocalData.homeMoodMeh.getString(context)),
      ('🙂', LocalData.homeMoodOkay.getString(context)),
      ('😄', LocalData.homeMoodGood.getString(context)),
      ('🤩', LocalData.homeMoodGreat.getString(context)),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalData.homeMoodCheckInTitle.getString(context),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: _deviceHeight * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((m) {
              final emoji = m.$1;
              final label = m.$2;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _incrementActivity(DateTime.now());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.formatString(
                            LocalData.homeMoodLoggedTemplate,
                            [label],
                          ),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _openMoodQuickPick(bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF0B2F4E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: _moodCheckInCard(isDarkMode)),
    );
  }

  // ================= ACTIVITY TRACKER =================

  Widget _activityTracker(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalData.homeActivityTitle.getString(context),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: _deviceHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _weeklyBarChart(isDarkMode),
        const SizedBox(height: 14),
        _activityRingsRow(isDarkMode),
        const SizedBox(height: 8),
        _streakBar(isDarkMode),
      ],
    );
  }

  Widget _weeklyBarChart(bool isDarkMode) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day);
    });
    final barGroups = days.map((d) {
      final v = (_activityData[d] ?? 0).toDouble();
      return BarChartGroupData(
        x: d.weekday,
        barRods: [
          BarChartRodData(
            toY: v,
            width: 14,
            borderRadius: BorderRadius.circular(4),
            color: isDarkMode
                ? Colors.greenAccent
                : const Color.fromARGB(255, 9, 43, 71),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 6,
              color: isDarkMode ? Colors.white12 : Colors.grey[200]!,
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: BarChart(
        BarChartData(
          maxY: 6,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  const w = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  final idx = (val.toInt() - 1) % 7;
                  return Text(
                    w[idx],
                    style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                        fontSize: 11),
                  );
                },
              ),
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _activityRingsRow(bool isDarkMode) {
    final today = DateTime.now();
    final key = DateTime(today.year, today.month, today.day);
    final todayCount = (_activityData[key] ?? 0).clamp(0, 6);
    final weekTotal = _activityData.entries
        .where((e) => today.difference(e.key).inDays < 7)
        .fold<int>(0, (a, b) => a + b.value)
        .clamp(0, 40);
    final streak = _computeStreak().clamp(0, 30);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ring(
            LocalData.homeRingToday.getString(context),
            todayCount / 6,
            '$todayCount',
            isDarkMode
                ? Colors.greenAccent
                : const Color.fromARGB(255, 9, 43, 71),
            isDarkMode),
        _ring(
            LocalData.homeRing7Days.getString(context),
            weekTotal / 40,
            '$weekTotal',
            isDarkMode ? Colors.tealAccent : Colors.teal,
            isDarkMode),
        _ring(
            LocalData.homeRingStreak.getString(context),
            streak / 30,
            '${streak}d',
            isDarkMode
                ? Colors.lightBlueAccent
                : Colors.lightBlue,
            isDarkMode),
      ],
    );
  }

  Widget _ring(String label, double pct, String center, Color color,
      bool isDarkMode) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularPercentIndicator(
                radius: 30,
                lineWidth: 6,
                percent: pct.clamp(0, 1),
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor:
                    isDarkMode ? Colors.white24 : Colors.grey[300]!,
                progressColor: color,
                center: Text(
                  center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streakBar(bool isDarkMode) {
    final streak = _computeStreak();
    final maxVisual = 30;
    final fill = (streak / maxVisual).clamp(0, 1.0);
    final label = context.formatString(
      LocalData.homeStreakBarTemplate,
      [streak.toString()],
    );
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: fill.toDouble(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF1EB980), const Color(0xFF0B6BB5)]
                      : [const Color.fromARGB(255, 9, 43, 71), Colors.lightBlue],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _incrementActivity(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    setState(() {
      _activityData[key] = (_activityData[key] ?? 0) + 1;
    });
  }
}