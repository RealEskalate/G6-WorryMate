import 'package:flutter/material.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedLang = 'EN';
  int _currentTab = 3;
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];

  Widget _exampleQuestion(String text, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        _sendMessage(text);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDarkMode ? Colors.greenAccent : const Color(0xFF22314A),
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : const Color(0xFF22314A),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text.trim(), isUser: true));
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _messages.add(
          _ChatMessage(text: _getDummyResponse(text), isUser: false),
        );
      });
    });
  }

  String _getDummyResponse(String userText) {
    return "Thanks for sharing! I'm here to help you with: '$userText'";
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;

    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : Colors.white;

    Color getPrimaryColor() => isDarkMode
        ? Colors.greenAccent
        : const Color(0xFF22314A);

    Color getTextColor() => isDarkMode
        ? Colors.white
        : Colors.black;

    Color getSubtitleColor() => isDarkMode
        ? Colors.white70
        : Colors.black54;

    Color getUserMessageColor() => isDarkMode
        ? Colors.greenAccent.withOpacity(0.2)
        : const Color(0xFFE8F0FE);

    Color getBotMessageColor() => isDarkMode
        ? Colors.white.withOpacity(0.15)
        : const Color(0xFF22314A);

    Color getInputBorderColor() => isDarkMode
        ? Colors.greenAccent
        : const Color(0xFF22314A);

    Color getInputBackgroundColor() => isDarkMode
        ? Colors.white.withOpacity(0.08)
        : Colors.white;

    Color getHintColor() => isDarkMode
        ? Colors.white60
        : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: getPrimaryColor(),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1,
                color: getPrimaryColor(),
              ),
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WorryMate",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: getTextColor(),
              ),
            ),
            Text(
              "Your AI worry buddy",
              style: TextStyle(
                color: getSubtitleColor(),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextButton(
                  onPressed: () {
                    setState(() => _selectedLang = 'EN');
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 1, color: getPrimaryColor()),
                    backgroundColor: _selectedLang == 'EN'
                        ? getPrimaryColor()
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'EN'
                        ? (isDarkMode ? Colors.black : Colors.white)
                        : getPrimaryColor(),
                  ),
                  child: const Text('EN'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextButton(
                  onPressed: () {
                    setState(() => _selectedLang = 'AM');
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 1, color: getPrimaryColor()),
                    backgroundColor: _selectedLang == 'AM'
                        ? getPrimaryColor()
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'AM'
                        ? (isDarkMode ? Colors.black : Colors.white)
                        : getPrimaryColor(),
                  ),
                  child: const Text('አማ'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: getBackgroundColor(),
              child: _messages.isEmpty
                  ? SingleChildScrollView(
                child: Column(
                  children: [
                    // Welcome message card
                    Container(
                      margin: const EdgeInsets.only(
                        top: 32,
                        left: 24,
                        right: 24,
                        bottom: 18,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: getPrimaryColor(),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Hey i am your worrybuddy, vent your problems' on me",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    // Try asking about
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 8,
                        bottom: 6,
                        right: 24,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Try asking about:',
                          style: GoogleFonts.poppins(
                            color: getSubtitleColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _exampleQuestion(
                            "I'm really stressed about my exams",
                            isDarkMode,
                          ),
                          _exampleQuestion(
                            "I lost my job and i'm worried about money.",
                            isDarkMode,
                          ),
                          _exampleQuestion(
                            "My family and i keep fighting.",
                            isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                itemCount: _messages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? getUserMessageColor()
                            : getBotMessageColor(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.text,
                        style: GoogleFonts.poppins(
                          color: msg.isUser
                              ? getTextColor()
                              : (isDarkMode ? Colors.white : Colors.white),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Input box at the bottom
          Container(
            color: getBackgroundColor(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: GoogleFonts.poppins(color: getHintColor()),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: getInputBorderColor(),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: getInputBorderColor(),
                          width: 2.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      fillColor: getInputBackgroundColor(),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic, color: getPrimaryColor()),
                        onPressed: () {},
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      color: getTextColor(),
                      fontSize: 15,
                    ),
                    onSubmitted: (val) {
                      _sendMessage(val);
                      _textController.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: getPrimaryColor()),
                  onPressed: () {
                    _sendMessage(_textController.text);
                    _textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          if (i == _currentTab) return;
          setState(() => _currentTab = i);
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
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}