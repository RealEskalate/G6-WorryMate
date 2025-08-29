import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    // Chat screen colors
    const background = Color.fromARGB(255, 9, 43, 71);
    const cardColor = Colors.white;
    const accent = Colors.greenAccent;
    const borderColor = Color(0xFFE0E6ED);
    const inputFill = Color(0xFFF7F9FB);
    const addBtnColor = Color(0xFF22314A);

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
          'Win Tracker',
          style: GoogleFonts.poppins(
            color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: addBtnColor),
                  const SizedBox(width: 8),
                  Text(
                    'Win Tracker',
                    style: GoogleFonts.poppins(
                      color: addBtnColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Add a new win:',
                style: GoogleFonts.poppins(
                  color: addBtnColor,
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
                        color: addBtnColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'I completed my assignment...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: inputFill,
                      ),
                      onSubmitted: (_) => _addWin(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addWin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: addBtnColor,
                      foregroundColor: Colors.white,
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
                      'Add',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Your Wins:',
                    style: GoogleFonts.poppins(
                      color: addBtnColor,
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
                      color: accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _wins.length.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
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
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start tracking your wins, no matter how small!',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
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
                      leading: Icon(Icons.check_circle, color: accent),
                      title: Text(
                        _wins[i],
                        style: GoogleFonts.poppins(
                          color: addBtnColor,
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

  void _addWin() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _wins.insert(0, text);
      _controller.clear();
    });
  }
}
