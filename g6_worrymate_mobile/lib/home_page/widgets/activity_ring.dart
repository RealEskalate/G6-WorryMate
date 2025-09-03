import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActivityRing extends StatelessWidget {
  final String label;
  final double percent; // 0..1
  final String centerText;
  final Color color;
  final bool isDarkMode;
  const ActivityRing({super.key, required this.label, required this.percent, required this.centerText, required this.color, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
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
                percent: percent.clamp(0, 1),
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                progressColor: color,
                center: Text(
                  centerText,
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
}
