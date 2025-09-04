import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../core/localization/locales.dart';

class Greetings extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  const Greetings({
    super.key,
    required this.isDarkMode,
    required this.deviceHeight,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final key = hour < 12
        ? LocalData.homeGreetingMorning
        : hour < 18
        ? LocalData.homeGreetingAfternoon
        : LocalData.homeGreetingEvening;
    final text = key.getString(context);
    return Text(
      '$text 👋',
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: deviceHeight * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
