import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:g6_worrymate_mobile/features/offline_toolkit/presentation/pages/offline_toolkit_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  // Hero (auto slideshow)
  late final PageController _heroPageController;
  Timer? _heroSlideTimer;
  final Duration _heroSlideInterval = const Duration(seconds: 5);
  final Duration _heroSlideAnimDuration = const Duration(milliseconds: 600);
  final Curve _heroSlideCurve = Curves.easeInOut;
  late final List<ImageProvider> _heroImages;

  int _selectedModule = 0;
  int _currentTab = 0;

  // Prompt input
  final TextEditingController _promptCtrl = TextEditingController();

  // Activity data (replace with persistence/backend)
  final Map<DateTime, int> _activityData = {DateTime.now(): 1};

  // Affirmations (cache index for rebuilds)
  final List<String> _affirmations = [
    'You are making progress, one small step at a time.',
    'Your feelings are valid.',
    'Breathing space creates thinking space.',
    'You deserve kindness—from yourself too.',
  ];
  late final int _affirmationIndex;

  // Quick AI prompts
  final List<String> _quickPrompts = [
    'Feeling anxious',
    'Improve sleep',
    'Low motivation',
    'Overthinking',
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
    _affirmationIndex = _affirmations.isNotEmpty
        ? Random().nextInt(_affirmations.length)
        : 0;
    _startHeroAutoSlide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache hero images for smoother first transition
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

  // Tab routing
  Widget _pageFor(int index) {
    switch (index) {
      case 0:
        return _contentLayer();
      case 1:
        return _stubPage('Journal (TODO)');
      case 2:
        return _stubPage('Wins (TODO)');
      case 3:
        // Cancel the hero slide timer before navigating to chat
        _heroSlideTimer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ModalRoute.of(context)?.settings.name != '/chat') {
            Navigator.of(context).pushNamed('/chat');
          }
        });
        return Container();
      case 4:
        return _stubPage('Profile (TODO)');
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
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    final bool showHero = _currentTab == 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 43, 71),
      body: Stack(
        children: [
          if (showHero) _heroModulesBackground(),
          if (showHero) _gradientOverlay(),
          Positioned.fill(child: _pageFor(_currentTab)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          if (i == _currentTab) return;
          switch (i) {
            case 0:
              // Home
              setState(() => _currentTab = 0);
              break;
            case 1:
              // Journal
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2:
              // Wins (Offline Toolkit)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfflineToolkitScreen(),
                ),
              );
              break;
            case 3:
              // Chat
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              // Settings
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  // ================= HERO BACKGROUND =================

  Widget _heroModulesBackground() {
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
                      Colors.black.withValues(alpha: 0.45),
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

  Widget _gradientOverlay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 0.85 * _deviceHeight,
        width: _deviceWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 9, 43, 71), Colors.transparent],
            stops: [0.65, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  // ================= FOREGROUND CONTENT =================

  Widget _contentLayer() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.05,
          vertical: _deviceHeight * 0.005,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(),
            SizedBox(height: _deviceHeight * 0.02),
            _greeting(),
            SizedBox(height: _deviceHeight * 0.02),
            _moduleHeader(),
            SizedBox(height: _deviceHeight * 0.02),
            _progressRow(),
            SizedBox(height: _deviceHeight * 0.02),
            _quickActionsRow(),
            SizedBox(height: _deviceHeight * 0.02),
            _dailyAffirmationCard(),
            SizedBox(height: _deviceHeight * 0.02),
            _aiPromptSection(),
            SizedBox(height: _deviceHeight * 0.02),
            _safetyBanner(),
            SizedBox(height: _deviceHeight * 0.025),
            _moodCheckInCard(),
            SizedBox(height: _deviceHeight * 0.02),
            _activityTracker(),
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

  Widget _topBar() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Worry ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: _deviceHeight * 0.035,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: 'Mate',
                  style: GoogleFonts.poppins(
                    color: Colors.greenAccent,
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
              const Icon(
                Icons.settings_rounded,
                size: 30,
                color: Colors.white,
                semanticLabel: 'Settings',
              ),
              SizedBox(width: _deviceWidth * 0.03),
              const Icon(
                Icons.notifications,
                size: 30,
                color: Colors.white,
                semanticLabel: 'Notifications',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
        ? 'Good afternoon'
        : 'Good evening';
    return Text(
      '$greeting 👋',
      style: TextStyle(
        color: Colors.white,
        fontSize: _deviceHeight * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ================= HERO TITLE + INDICATORS =================

  Widget _moduleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          featuredAppServices[_selectedModule].title,
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
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
                color: active ? Colors.greenAccent : Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ================= STATS ROW =================

  Widget _progressRow() {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final weekCount = _activityData.keys
        .where((d) => now.difference(d).inDays < 7)
        .length;
    final streak = _computeStreak();
    return Row(
      children: [
        _miniStat('Streak', '${streak}d', Icons.local_fire_department),
        const SizedBox(width: 12),
        _miniStat('This Week', '$weekCount', Icons.calendar_today),
        const SizedBox(width: 12),
        _miniStat(
          'Today',
          '${_activityData[todayKey] ?? 0}',
          Icons.bubble_chart,
        ),
      ],
    );
  }

  int _computeStreak() {
    final dates =
        _activityData.keys
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

  Widget _miniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= QUICK ACTIONS =================

  Widget _quickActionsRow() {
    final actions = [
      (Icons.edit_note, 'Journal'),
      (Icons.mood, 'Mood'),
      (Icons.spa, 'Breathing'),
      (Icons.chat_bubble, 'Chat AI'),
    ];
    return SizedBox(
      height: _deviceHeight * 0.11,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final pair = actions[i];
          final icon = pair.$1;
          final label = pair.$2;
          return GestureDetector(
            onTap: () {
              if (label == 'Mood') _openMoodQuickPick();
            },
            child: Container(
              width: _deviceWidth * 0.23,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 9, 43, 71), Color(0xFF094470)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
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

  Widget _dailyAffirmationCard() {
    final affirmation = _affirmations[_affirmationIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber[300], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              affirmation,
              style: const TextStyle(
                color: Colors.white,
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

  Widget _aiPromptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ask for support',
          style: TextStyle(
            color: Colors.white,
            fontSize: _deviceHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_quickPrompts.length, (i) {
            final p = _quickPrompts[i];
            final selected = _promptCtrl.text.trim() == p;
            return GestureDetector(
              onTap: () => setState(() => _promptCtrl.text = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.greenAccent.withValues(alpha: 0.25)
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: selected ? Colors.greenAccent : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Text(
                  p,
                  style: TextStyle(
                    color: selected ? Colors.greenAccent : Colors.white70,
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
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Describe how you feel or ask a question...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 3,
                  onSubmitted: (_) => _submitPrompt(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.greenAccent),
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
      const SnackBar(
        content: Text('Prompt sent'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ================= SAFETY BANNER =================

  Widget _safetyBanner() {
    // fallback index safe
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
            Colors.black.withValues(alpha: 0.55),
            BlendMode.darken,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.04),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.greenAccent,
              size: 42,
            ),
          ),
          Expanded(
            child: Text(
              'Safety resources\nQuick help if needed',
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

  Widget _moodCheckInCard() {
    final moods = [
      ('😞', 'Low'),
      ('😐', 'Meh'),
      ('🙂', 'Okay'),
      ('😄', 'Good'),
      ('🤩', 'Great'),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood check-in',
            style: TextStyle(
              color: Colors.white,
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
                        content: Text('Logged mood: $label'),
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
                          style: const TextStyle(
                            color: Colors.white70,
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

  void _openMoodQuickPick() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B2F4E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) =>
          Padding(padding: const EdgeInsets.all(24), child: _moodCheckInCard()),
    );
  }

  // REPLACE _activityTracker():
  Widget _activityTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: _deviceHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _weeklyBarChart(),
        const SizedBox(height: 14),
        _activityRingsRow(),
        const SizedBox(height: 8),
        _streakBar(),
      ],
    );
  }

  // Weekly bar (uses past 7 days)
  Widget _weeklyBarChart() {
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
            color: Colors.greenAccent,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 6, // expected max
              color: Colors.white12,
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
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
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
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

  // Activity rings (example metrics – adapt)
  Widget _activityRingsRow() {
    // Derive pseudo metrics
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
        _ring('Today', todayCount / 6, '$todayCount', Colors.greenAccent),
        _ring('7 Days', weekTotal / 40, '$weekTotal', Colors.tealAccent),
        _ring('Streak', streak / 30, '${streak}d', Colors.lightBlueAccent),
      ],
    );
  }

  Widget _ring(String label, double pct, String center, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white10,
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
                backgroundColor: Colors.white24,
                progressColor: color,
                center: Text(
                  center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
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

  // Streak bar
  Widget _streakBar() {
    final streak = _computeStreak();
    final maxVisual = 30;
    final fill = (streak / maxVisual).clamp(0, 1.0);
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(30),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: fill.toDouble(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1EB980), Color(0xFF0B6BB5)],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Streak: $streak',
              style: const TextStyle(
                color: Colors.white,
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
  // ================= ACTIVITY / HEATMAP =================

  void _incrementActivity(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    setState(() {
      _activityData[key] = (_activityData[key] ?? 0) + 1;
    });
  }
}
