import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class FiveFourScreen extends StatefulWidget {
  const FiveFourScreen({super.key});

  @override
  State<FiveFourScreen> createState() => _FiveFourScreenState();
}

class _FiveFourScreenState extends State<FiveFourScreen> {
  int _currentStep = 0;

  final List<String> _steps = [
    'Look around and name 5 things you can see',
    'Listen carefully and name 4 things you can hear',
    'Touch and name 3 things you can feel',
    'Think of 2 things you can smell',
    'Name 1 thing you can taste',
  ];

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
        : const Color(0xFF7B8CA6);

    Color getBorderColor() => isDarkMode
        ? Colors.greenAccent.withOpacity(0.3)
        : const Color(0xFFE0E6ED);

    Color getStepInactiveColor() => isDarkMode
        ? Colors.white.withOpacity(0.05)
        : const Color(0xFFF7F9FB);

    Color getStepInactiveText() => isDarkMode
        ? Colors.white60
        : const Color(0xFF7B8CA6);

    Color getButtonTextColor() => isDarkMode
        ? Colors.white
        : const Color.fromARGB(255, 9, 43, 71);

    Color getButtonBackgroundColor() => isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.white;

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
          '5-4-3-2-1 Grounding',
          style: GoogleFonts.poppins(
            color: getTextColor(),
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.2,
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

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.adjust, color: accent),
                    const SizedBox(width: 8),
                    Expanded(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.adjust, color: getPrimaryColor()),
                  const SizedBox(width: 8),
                  Text(
                    '5-4-3-2-1 Grounding Exercise',
                    style: GoogleFonts.poppins(
                      color: getTextColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                backgroundColor: getBorderColor(),
                valueColor: AlwaysStoppedAnimation<Color>(getPrimaryColor()),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 18),
              ...List.generate(_steps.length, (i) {
                final isActive = i == _currentStep;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? getPrimaryColor().withOpacity(0.08)
                        : getStepInactiveColor(),
                    border: Border.all(
                      color: isActive ? getPrimaryColor() : getBorderColor(),
                      width: isActive ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive ? getPrimaryColor() : getBorderColor(),
                      child: Text(
                        '5-4-3-2-1 Grounding Exercise',
                        style: GoogleFonts.poppins(

                          color: stepActiveColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: isActive ? Colors.white : getStepInactiveText(),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / _steps.length,
                  backgroundColor: borderColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(accent),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 18),
                ...List.generate(_steps.length, (i) {
                  final isActive = i == _currentStep;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? accent.withOpacity(0.08)
                          : stepInactiveColor,
                      border: Border.all(
                        color: isActive ? accent : borderColor,
                        width: isActive ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isActive ? accent : Colors.grey[300],
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.poppins(
                            color: isActive ? Colors.white : stepInactiveText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        _steps[i],
                        style: GoogleFonts.poppins(
                          color: isActive ? stepActiveColor : stepInactiveText,
                          fontWeight: isActive
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 15,

                    title: Text(
                      _steps[i],
                      style: GoogleFonts.poppins(
                        color: isActive ? getTextColor() : getStepInactiveText(),
                        fontWeight: isActive
                            ? FontWeight.w500
                            : FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentStep > 0
                        ? () => setState(() => _currentStep--)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonBackgroundColor(),
                      foregroundColor: getButtonTextColor(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: getPrimaryColor()),
                    ),
                    child: Text(
                      'Previous',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => _currentStep = 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getButtonBackgroundColor(),
                          foregroundColor: getButtonTextColor(),
                          elevation: 0,
                          side: BorderSide(color: getPrimaryColor()),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.refresh, size: 18, color: getButtonTextColor()),
                            const SizedBox(width: 4),
                            Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                color: getButtonTextColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentStep > 0
                            ? () => setState(() => _currentStep--)
                            : null,
                        style: ElevatedButton.styleFrom(

                          backgroundColor: getPrimaryColor(),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: accent),
                        ),
                        child: Text(
                          'Previous',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => _currentStep = 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: accent,
                            elevation: 0,
                            side: const BorderSide(color: accent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.refresh,
                                size: 18,
                                color: accent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reset',
                                style: GoogleFonts.poppins(
                                  color: accent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _currentStep < _steps.length - 1
                              ? () => setState(() => _currentStep++)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}