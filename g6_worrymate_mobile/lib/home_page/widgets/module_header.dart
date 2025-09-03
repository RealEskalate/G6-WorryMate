import 'package:flutter/material.dart';

class ModuleHeader extends StatelessWidget {
  final bool isDarkMode;
  final int selectedIndex;
  final List<String> titles;
  final double deviceHeight;
  const ModuleHeader({super.key, required this.isDarkMode, required this.selectedIndex, required this.titles, required this.deviceHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titles[selectedIndex],
          maxLines: 2,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: deviceHeight * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: deviceHeight * 0.008),
        Row(
          children: List.generate(titles.length, (i) {
            final active = i == selectedIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: deviceHeight * 0.008),
              height: deviceHeight * 0.01,
              width: active ? deviceHeight * 0.035 : deviceHeight * 0.015,
              decoration: BoxDecoration(
                color: active
                    ? (isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71))
                    : (isDarkMode ? Colors.white24 : Colors.grey[400]),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
