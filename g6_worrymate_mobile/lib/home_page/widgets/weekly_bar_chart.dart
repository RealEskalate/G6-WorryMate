import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyBarChart extends StatelessWidget {
  final bool isDarkMode;
  final Map<DateTime, int> activityData; // normalized keys (Y/M/D)
  const WeeklyBarChart({super.key, required this.isDarkMode, required this.activityData});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day);
    });
    final barGroups = days.map((d) {
      final v = (activityData[d] ?? 0).toDouble();
      return BarChartGroupData(
        x: d.weekday,
        barRods: [
          BarChartRodData(
            toY: v,
            width: 14,
            borderRadius: BorderRadius.circular(4),
            color: isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 9, 43, 71),
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
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
}
