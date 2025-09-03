import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../core/localization/locales.dart';

class MoodCheckInCard extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  final void Function(String label) onMoodSelected;
  const MoodCheckInCard({super.key, required this.isDarkMode, required this.deviceHeight, required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
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
              fontSize: deviceHeight * 0.02,
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
                  onTap: () => onMoodSelected(label),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
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
}
