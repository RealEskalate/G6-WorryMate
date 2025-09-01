import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    const background = Color.fromARGB(255, 9, 43, 71); // chat screen bg
    const cardColor = Colors.white;
    const accent = Color.fromARGB(255, 9, 43, 71); // blue accent
    const borderColor = Color(0xFFE0E6ED);
    const stepActiveColor = Color(0xFF22314A); // dark blue
    const stepInactiveColor = Color(0xFFF7F9FB);
    const stepInactiveText = Color(0xFF7B8CA6);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '5-4-3-2-1 Grounding',
          style: GoogleFonts.poppins(
            color: Colors.white,
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
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
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
                      child: Text(
                        '5-4-3-2-1 Grounding Exercise',
                        style: GoogleFonts.poppins(
                          color: stepActiveColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
                          backgroundColor: Colors.white,
                          foregroundColor: accent,
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
