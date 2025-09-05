import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive/hive.dart'; // Import Hive
import 'package:provider/provider.dart';
import '../../../../core/localization/locales.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class WinTrackerScreen extends StatefulWidget {
  const WinTrackerScreen({super.key});

  @override
  State<WinTrackerScreen> createState() => _WinTrackerScreenState();
}

class _WinTrackerScreenState extends State<WinTrackerScreen> {
  final TextEditingController _controller = TextEditingController();

  late Box _winBox; // Declare Hive box
  List<Map<String, dynamic>> _wins = []; // Change to Map to store more data if needed, currently just 'text' and 'id'

  @override
  void initState() {
    super.initState();
    _openWinBox();
  }

  Future<void> _openWinBox() async {
    _winBox = await Hive.openBox('winBox');
    _loadWins();
  }

  void _loadWins() {
    // Load wins from Hive, ensure they are in the correct format (Map<String, dynamic>)
    final storedWins = _winBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
    setState(() {
      _wins = storedWins.reversed.toList(); // Display newest wins first, matching your original _wins.insert(0, text)
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // No need to close the box explicitly here if it's managed by the app lifecycle
    // _winBox.close(); // Only close if you are absolutely done with it and not relying on app-wide management
    super.dispose();
  }

  void _addWin() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newWin = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      'text': text,
      'createdAt': DateTime.now().toIso8601String(), // Timestamp
    };

    _winBox.add(newWin); // Add to Hive
    setState(() {
      _wins.insert(0, newWin); // Add to UI list at the beginning
      _controller.clear();
    });
  }

  // New: Function to remove a win
  void _removeWin(Map<String, dynamic> winToRemove) {
    // Find the key of the win in the Hive box. Hive doesn't always use list indices
    // when you use .add(). It generates its own auto-incrementing integer keys.
    // So, we need to find the actual key associated with the win.
    final Map<dynamic, dynamic> winsMap = _winBox.toMap();
    dynamic keyToDelete;
    winsMap.forEach((key, value) {
      if (value['id'] == winToRemove['id']) {
        keyToDelete = key;
      }
    });

    if (keyToDelete != null) {
      _winBox.delete(keyToDelete).then((_) {
        setState(() {
          _wins.removeWhere((win) => win['id'] == winToRemove['id']);
        });
      }).catchError((error) {
        // Handle error if deletion fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Could not delete win.')),
          );
        }
      });
    }
  }

  // New: Function to update a win
  void _updateWin(int uiIndex, Map<String, dynamic> oldWin, String updatedText) {
    // Find the key of the win in the Hive box based on its 'id'
    final Map<dynamic, dynamic> winsMap = _winBox.toMap();
    dynamic keyToUpdate;
    winsMap.forEach((key, value) {
      if (value['id'] == oldWin['id']) {
        keyToUpdate = key;
      }
    });

    if (keyToUpdate != null) {
      final updatedWin = {
        ...oldWin, // Keep existing fields
        'text': updatedText, // Update the text
      };
      _winBox.put(keyToUpdate, updatedWin).then((_) {
        setState(() {
          _wins[uiIndex] = updatedWin; // Update the UI list
        });
      }).catchError((error) {
        // Handle error if update fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Could not update win.')),
          );
        }
      });
    }
  }

  // New: Method to show the edit dialog for a win
  void _showEditWinDialog(int uiIndex, Map<String, dynamic> winToEdit) {
    final TextEditingController editController = TextEditingController(text: winToEdit['text']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeManager = Provider.of<ThemeManager>(context, listen: false);
        final isDarkMode = themeManager.isDarkMode;

        Color getTextColor() => isDarkMode ? Colors.white : Colors.black87;
        Color getInputBackgroundColor() =>
            isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF7F9FB);
        Color getBorderColor() => isDarkMode
            ? Colors.greenAccent.withOpacity(0.3)
            : const Color(0xFFE0E6ED);
        Color getPrimaryColor() =>
            isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 9, 43, 71);

        return AlertDialog(
          backgroundColor: isDarkMode ? const Color.fromARGB(255, 9, 43, 71) : Colors.white,
          title: Text("Edit Your Win", style: GoogleFonts.poppins(color: getTextColor())),
          content: TextField(
            controller: editController,
            style: GoogleFonts.poppins(color: getTextColor()),
            decoration: InputDecoration(
              labelText: "Win Description",
              labelStyle: GoogleFonts.poppins(color: getTextColor().withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: getBorderColor()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: getBorderColor()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: getPrimaryColor(), width: 2),
              ),
              filled: true,
              fillColor: getInputBackgroundColor(),
            ),
            minLines: 1,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: getPrimaryColor())),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedText = editController.text.trim();
                if (updatedText.isNotEmpty) {
                  _updateWin(uiIndex, winToEdit, updatedText);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: getPrimaryColor(),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Save", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
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
          width: double.infinity, // Fixed potential overflow issue
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
                Expanded( // Use Expanded to give ListView remaining height
                  child: ListView.builder(
                    itemCount: _wins.length,
                    itemBuilder: (context, i) {
                      final win = _wins[i];
                      return Dismissible(
                        key: ValueKey(win['id']), // Use unique ID for Dismissible key
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: const Color.fromRGBO(239, 68, 68, 1), // Red delete background
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _removeWin(win),
                        child: GestureDetector( // Added for edit functionality
                          onTap: () => _showEditWinDialog(i, win),
                          child: ListTile(
                            leading: Icon(Icons.check_circle, color: getAccentColor()),
                            title: Text(
                              win['text'] as String, // Cast to String
                              style: GoogleFonts.poppins(
                                color: getTextColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton( // Optional: explicit edit button
                              icon: Icon(Icons.edit, color: getSubtitleColor()),
                              onPressed: () => _showEditWinDialog(i, win),
                            ),
                          ),
                        ),
                      );
                    },
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