import 'package:flutter/material.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'box_breathing_screen.dart';
import 'daily_journal_screen.dart';
import 'five_four_screen.dart';
import 'win_tracker_screen.dart';

class OfflineToolkitScreen extends StatefulWidget {
  const OfflineToolkitScreen({super.key});

  @override
  State<OfflineToolkitScreen> createState() => _OfflineToolkitScreenState();
}

class _OfflineToolkitScreenState extends State<OfflineToolkitScreen> {
  int _currentTab = 2;

  Widget _buildToolCard({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.greenAccent,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 43, 71),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 43, 71),
        elevation: 0,
       
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offline Toolkit',
              style: GoogleFonts.poppins(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Wellness tools that work without internet',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Works Offline',
              style: GoogleFonts.poppins(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToolCard(
              color: const Color(0xFF007AFF),
              icon: Icons.favorite_border,
              title: 'Box Breathing',
              description: '4-4-4-4 breathing pattern to calm your mind',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoxBreathingScreen()),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFF34C759),
              icon: Icons.camera_alt_outlined,
              title: '5-4-3-2-1 Grounding',
              description: 'Focus on your senses to stay present',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FiveFourScreen(),
                  ),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFFAF52DE),
              icon: Icons.book_outlined,
              title: 'Daily Journal',
              description: 'Reflect on your thoughts and feelings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DailyJournalScreen(),
                  ),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFFFF9500),
              icon: Icons.trending_up,
              title: 'Win Tracker',
              description: 'Celebrate small victories and progress',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WinTrackerScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          if (i == _currentTab) return;
          setState(() => _currentTab = i);
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2:
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
}
