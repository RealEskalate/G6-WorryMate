import 'package:flutter/material.dart';

class DailyAffirmationCard extends StatelessWidget {
  final bool isDarkMode;
  final String affirmation;
  const DailyAffirmationCard({super.key, required this.isDarkMode, required this.affirmation});

  @override
  Widget build(BuildContext context) {
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
}
