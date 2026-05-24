import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class BoxBreathingScreen extends StatefulWidget {
  const BoxBreathingScreen({super.key});

  @override
  State<BoxBreathingScreen> createState() => _BoxBreathingScreenState();
}

class _BoxBreathingScreenState extends State<BoxBreathingScreen> {
  static const List<String> _steps = [
    'Breathe In',
    'Hold',
    'Breathe Out',
    'Hold',
  ];
  static const int _stepDuration = 4; // seconds per step
  int _currentStep = 0;
  int _secondsLeft = _stepDuration;
  bool _isRunning = false;
  Timer? _timer;

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _currentStep = 0;
      _secondsLeft = _stepDuration;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          if (_currentStep < _steps.length - 1) {
            _currentStep++;
            _secondsLeft = _stepDuration;
          } else {
            // End of cycle
            _isRunning = false;
            _timer?.cancel();
          }
        }
      });
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _currentStep = 0;
      _secondsLeft = _stepDuration;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : Colors.white;

    Color getCardColor() => isDarkMode
        ? Colors.white.withOpacity(0.08)
        : Colors.white;

    Color getPrimaryColor() => isDarkMode
        ? Colors.greenAccent
        : const Color.fromARGB(255, 9, 43, 71);

    Color getTextColor() => isDarkMode
        ? Colors.white
        : Colors.black;

    Color getSubtitleColor() => isDarkMode
        ? Colors.white70
        : Colors.black54;

    Color getIconColor() => isDarkMode
        ? Colors.white
        : const Color.fromARGB(255, 9, 43, 71);

    Color getBorderColor() => isDarkMode
        ? Colors.greenAccent.withOpacity(0.3)
        : Colors.grey[300]!;

    Color getButtonColor() => isDarkMode
        ? const Color(0xFF22314A)
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
          'Box Breathing',
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
          padding: const EdgeInsets.all(32),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_border, color: getPrimaryColor()),
                  const SizedBox(width: 8),
                  Text(
                    'Box Breathing Exercise',
                    style: GoogleFonts.poppins(
                      color: getIconColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: getPrimaryColor().withOpacity(0.3),
                    width: 5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: getIconColor(),
                        size: 54,
                      ),
                      const SizedBox(height: 8),
                      if (_isRunning)
                        Text(
                          '${_steps[_currentStep]}',
                          style: GoogleFonts.poppins(
                            color: getIconColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      if (_isRunning)
                        Text(
                          '$_secondsLeft',
                          style: GoogleFonts.poppins(
                            color: getIconColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Breathe in for 4 seconds, hold for 4, exhale for 4, hold for 4',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: getSubtitleColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),
              if (!_isRunning)
                SizedBox(
                  width: 180,
                  height: 44,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.play_arrow, color: Colors.white),
                    label: Text(
                      'Start Breathing',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _startBreathing,
                  ),
                ),
              if (_isRunning)
                SizedBox(
                  width: 120,
                  height: 44,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.stop, color: Colors.white),
                    label: Text(
                      'Reset',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _reset,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}