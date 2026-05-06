import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : Colors.white;

    Color getSelectedItemColor() => isDarkMode
        ? Colors.greenAccent
        : const Color(0xFF22314A);

    Color getUnselectedItemColor() => isDarkMode
        ? Colors.white54
        : Colors.grey[600]!;

    Color getIconColor(int index) => currentIndex == index
        ? getSelectedItemColor()
        : getUnselectedItemColor();

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: getBackgroundColor(),
      elevation: 8,
      selectedItemColor: getSelectedItemColor(),
      unselectedItemColor: getUnselectedItemColor(),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded, color: getIconColor(0)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_note_rounded, color: getIconColor(1)),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_rounded, color: getIconColor(2)),
          label: 'Offline Pack',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded, color: getIconColor(3)),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: getIconColor(4)),
          label: 'Settings',
        ),
      ],
    );
  }
}