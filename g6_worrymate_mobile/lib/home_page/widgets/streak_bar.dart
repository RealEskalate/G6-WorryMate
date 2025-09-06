import 'package:flutter/material.dart';

class StreakBar extends StatelessWidget {
  final bool isDarkMode;
  final int streak;
  final int maxVisual;
  final double height;
  final String label;
  const StreakBar({super.key, required this.isDarkMode, required this.streak, this.maxVisual = 30, this.height = 20, required this.label});

  @override
  Widget build(BuildContext context) {
    final fill = (streak / maxVisual).clamp(0, 1.0);
    return Container(
      height: height,
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
}
