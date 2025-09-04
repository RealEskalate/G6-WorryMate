import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../../core/localization/locales.dart';

class DailyJournalScreen extends StatefulWidget {
  const DailyJournalScreen({super.key});

  @override
  State<DailyJournalScreen> createState() => _DailyJournalScreenState();
}

class _DailyJournalScreenState extends State<DailyJournalScreen> {
  final List<String> _promptKeys = [
    LocalData.journalPromptFeelingNow,
    LocalData.journalPromptSmileToday,
    LocalData.journalPromptGrateful,
    LocalData.journalPromptChallengeOvercome,
    LocalData.journalPromptHopeTomorrow,
  ];

  final TextEditingController _controller = TextEditingController();
  int? _selectedPromptIdx;

  late Box _journalBox;
  List<Map<String, String>> _entries = [];

  @override
  void initState() {
    super.initState();
    _journalBox = Hive.box('journalBox');
    _loadEntries();
  }

  void _loadEntries() {
    final stored = _journalBox.values.toList();
    setState(() {
      _entries = stored.map((e) => Map<String, String>.from(e)).toList();
    });
  }

  // FIX 1: The remove function now accepts the entry object itself.
  void _removeEntry(Map<String, String> entryToRemove) {
    // Find the actual index of the item in the Hive box before removing it from the UI list.
    final int originalIndex = _entries.indexOf(entryToRemove);
    if (originalIndex == -1) return; // Item not found, do nothing.

    // Optimistically remove from the UI state list first for a responsive feel.
    setState(() {
      _entries.remove(entryToRemove);
    });

    // Now, delete from the Hive database at the correct index.
    _journalBox.deleteAt(originalIndex).catchError((error) {
      // If the deletion fails, add the entry back to the UI to stay in sync.
      if (mounted) {
        setState(() {
          _entries.insert(originalIndex, entryToRemove);
        });
        // Optionally, show an error message to the user.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not delete entry.')),
        );
      }
    });
  }

  void _saveEntry(Map<String, String> entry) {
    _journalBox.add(entry);
    // FIX 2: Performance improvement. Instead of reloading all entries,
    // just add the new one to the current state list.
    setState(() {
      _entries.add(entry);
    });
  }

  void _sendEntry() {
    final text = _controller.text.trim();
    if (text.isEmpty || _selectedPromptIdx == null) return;
    final entry = {
      // FIX 3: Add a unique, stable ID to each entry. A timestamp is perfect for this.
      'id': DateTime.now().toIso8601String(),
      'promptKey': _promptKeys[_selectedPromptIdx!],
      'response': text,
    };
    _saveEntry(entry);
    setState(() {
      _controller.clear();
      _selectedPromptIdx = null;
    });
  }
  @override
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : const Color(0xFFF7F9FB);

    Color getCardColor() =>
        isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white;

    Color getTextColor() => isDarkMode ? Colors.white : Colors.black87;

    Color getSubtitleColor() => isDarkMode ? Colors.white70 : Colors.black54;

    Color getPrimaryColor() =>
        isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 9, 43, 71);

    Color getBorderColor() => isDarkMode
        ? Colors.greenAccent.withOpacity(0.3)
        : const Color(0xFFE0E6ED);

    Color getInputBackgroundColor() =>
        isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF7F9FB);

    Color getHintColor() => isDarkMode ? Colors.white60 : Colors.grey[500]!;

    Color getEntryBackgroundColor() =>
        isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(),
        elevation: 0,
        title: Text(
          LocalData.dailyJournalTitle.getString(context),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.library_books_outlined, color: getPrimaryColor()),
                    const SizedBox(width: 8),
                    Text(
                      LocalData.dailyJournalTitle.getString(context),
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
                  LocalData.journalPromptsHeading.getString(context),
                  style: GoogleFonts.poppins(
                    color: getTextColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                ..._promptKeys.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final key = entry.value;
                  final isSelected = _selectedPromptIdx == idx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPromptIdx = idx),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? getPrimaryColor().withOpacity(0.08)
                            : getInputBackgroundColor(),
                        border: Border.all(
                          color:
                          isSelected ? getPrimaryColor() : getBorderColor(),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color:
                            isSelected ? getPrimaryColor() : getHintColor(),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              key.getString(context),
                              style: GoogleFonts.poppins(
                                color: getTextColor(),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),
                Text(
                  LocalData.journalYourThoughtsLabel.getString(context),
                  style: GoogleFonts.poppins(
                    color: getTextColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 3,
                        maxLines: 6,
                        style: GoogleFonts.poppins(
                          color: getTextColor(),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          LocalData.journalInputHint.getString(context),
                          hintStyle: GoogleFonts.poppins(
                            color: getHintColor(),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: getBorderColor()),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: getBorderColor()),
                          ),
                          filled: true,
                          fillColor: getInputBackgroundColor(),
                        ),
                        onSubmitted: (_) => _sendEntry(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getPrimaryColor(),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.send, size: 30.0),
                  ),
                ),
                const SizedBox(height: 18),
                if (_entries.isNotEmpty) ...[
                  Text(
                    LocalData.journalEntriesHeading.getString(context),
                    style: GoogleFonts.poppins(
                      color: getTextColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _entries.length,
                    itemBuilder: (context, i) {
                      final entry = _entries[i];
                      final promptKey = entry['promptKey'] ?? '';
                      return Dismissible(
                        key: ValueKey(entry['id']),
                        background: Container(
                          color: const Color.fromRGBO(239, 68, 68, 1),
                          alignment: Alignment.centerRight,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child:
                          const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _removeEntry(entry),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: getEntryBackgroundColor(),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: getBorderColor()),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promptKey.getString(context),
                                style: GoogleFonts.poppins(
                                  color: getPrimaryColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                entry['response'] ?? '',
                                style: GoogleFonts.poppins(
                                  color: getTextColor(),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ], // ✅ FIX: The extra '),' was removed from this line.
                const SizedBox(height: 10),
                Text(
                  LocalData.journalEntriesPrivacyNote.getString(context),
                  style: GoogleFonts.poppins(
                    color: getSubtitleColor(),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (i) {
          // if (i == 4) return;
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/offlinetoolkit');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/settings');
              break;

          }
        },
      ),
    );
  }}
