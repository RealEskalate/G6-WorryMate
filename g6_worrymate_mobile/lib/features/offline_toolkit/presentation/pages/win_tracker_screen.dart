import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/localization/locales.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class WinTrackerScreen extends StatefulWidget {
  const WinTrackerScreen({super.key});

  @override
  State<WinTrackerScreen> createState() => _WinTrackerScreenState();
}

class _WinTrackerScreenState extends State<WinTrackerScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _wins = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addWin() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _wins.insert(0, text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : const Color(0xFFF7F9FB);

    Color getCardColor() => isDarkMode
        ? Colors.white.withOpacity(0.08)
        : Colors.white;

    Color getPrimaryColor() => isDarkMode
        ? Colors.greenAccent
        : const Color.fromARGB(255, 9, 43, 71);

    Color getTextColor() => isDarkMode
        ? Colors.white
        : const Color(0xFF22314A);

    Color getSubtitleColor() => isDarkMode
        ? Colors.white70
        : Colors.grey[600]!;

    Color getBorderColor() => isDarkMode
        ? Colors.greenAccent.withOpacity(0.3)
        : const Color(0xFFE0E6ED);

    Color getInputFillColor() => isDarkMode
        ? Colors.white.withOpacity(0.05)
        : const Color(0xFFF7F9FB);

    Color getHintColor() => isDarkMode
        ? Colors.white60
        : Colors.grey[500]!;

    Color getButtonColor() => isDarkMode
        ? Colors.white.withOpacity(0.1)
        : const Color(0xFF22314A);

    Color getButtonTextColor() => isDarkMode
        ? Colors.white
        : Colors.white;

    Color getAccentColor() => isDarkMode
        ? Colors.greenAccent
        : const Color.fromARGB(255, 9, 43, 71);

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getTextColor()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocalData.winTrackerTitle.getString(context),
          style: GoogleFonts.poppins(
            color: getTextColor(),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 420,
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getCardColor(),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: getBorderColor()),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.04 : 0.02),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: getPrimaryColor()),
                  const SizedBox(width: 8),
                  Text(
                    LocalData.winTrackerTitle.getString(context),
                    style: GoogleFonts.poppins(
                      color: getTextColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                LocalData.winTrackerAddLabel.getString(context),
                style: GoogleFonts.poppins(
                  color: getTextColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.poppins(
                        color: getTextColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: LocalData.winTrackerHint.getString(context),
                        hintStyle: GoogleFonts.poppins(color: getHintColor()),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: getBorderColor()),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: getBorderColor()),
                        ),
                        filled: true,
                        fillColor: getInputFillColor(),
                      ),
                      onSubmitted: (_) => _addWin(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addWin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonColor(),
                      foregroundColor: getButtonTextColor(),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      LocalData.winTrackerAddButton.getString(context),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    LocalData.winTrackerYourWins.getString(context),
                    style: GoogleFonts.poppins(
                      color: getTextColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: getAccentColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _wins.length.toString(),
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_wins.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: getSubtitleColor(),
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocalData.winTrackerEmptyState.getString(context),
                        style: GoogleFonts.poppins(
                          color: getSubtitleColor(),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: _wins.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: Icon(Icons.check_circle, color: getAccentColor()),
                      title: Text(
                        _wins[i],
                        style: GoogleFonts.poppins(
                          color: getTextColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}