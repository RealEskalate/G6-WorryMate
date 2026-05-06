import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../core/localization/locales.dart';
import '../functions/streak_calculator.dart';

class ProgressRow extends StatelessWidget{
  final bool isDarkMode;
  final Map<DateTime, int> activityData;
  const ProgressRow({super.key, required this.isDarkMode, required this.activityData});
      @override
      Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final weekCount =
        activityData.keys.where((d) => now.difference(d).inDays < 7).length;
    final streak = computeStreak(activityData);
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
          '${activityData[todayKey] ?? 0}',
          Icons.bubble_chart,
          isDarkMode,
        ),
      ],
    );
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
}