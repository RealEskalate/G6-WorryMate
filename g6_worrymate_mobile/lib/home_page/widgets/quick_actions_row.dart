import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../core/localization/locales.dart';

class QuickActionsRow extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  final double deviceWidth;
  final ValueChanged<String>? onActionTap; // Emits the action id

  const QuickActionsRow({
    super.key,
    required this.isDarkMode,
    required this.deviceHeight,
    required this.deviceWidth,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    // (icon, localized label, id)
    final actions = [
      (Icons.edit_note, LocalData.homeQuickJournal.getString(context), 'journal'),
      (Icons.spa, LocalData.homeQuickBreathing.getString(context), 'breathing'),
      (Icons.emoji_events, LocalData.homeQuickTrackWins.getString(context), 'trackWins'),
      (Icons.chat_bubble, LocalData.homeQuickChatAI.getString(context), 'chatAI'),
    ];

    return SizedBox(
      height: deviceHeight * 0.11,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final icon = actions[i].$1;
          final label = actions[i].$2;
          final id = actions[i].$3;
          return GestureDetector(
            onTap: () => onActionTap?.call(id),
            child: Container(
              width: deviceWidth * 0.23,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color.fromARGB(255, 9, 43, 71), const Color(0xFF094470)]
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
                  Icon(
                    icon,
                    color: isDarkMode ? Colors.white : const Color.fromARGB(255, 9, 43, 71),
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
}