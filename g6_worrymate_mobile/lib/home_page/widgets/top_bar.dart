import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/localization/locales.dart';
import '../../features/reminder/presentation/pages/reminder_page.dart';

class TopBar extends StatelessWidget {
  final double deviceHeight;
  final double deviceWidth;
  final bool isDarkMode;
  final BuildContext context;

  const TopBar({
    super.key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.isDarkMode,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${LocalData.appBrandPart1.getString(this.context)} ',
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: deviceHeight * 0.035,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: LocalData.appBrandPart2.getString(this.context),
                  style: GoogleFonts.poppins(
                    color: isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71),
                    fontSize: deviceHeight * 0.035,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.settings_rounded,
                size: 30,
                color: isDarkMode ? Colors.white : Colors.black,
                semanticLabel: 'Settings',
              ),
              SizedBox(width: deviceWidth * 0.03),
              IconButton(
                onPressed: () => showReminderSheet(context),
                icon: Icon(
                  Icons.timer_sharp,
                  size: 30,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                tooltip: LocalData.reminderTitle.getString(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
