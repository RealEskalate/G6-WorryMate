import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/params/params.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../crisis_card/presentation/pages/crisis_card.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final TextEditingController _textController = TextEditingController();
  final int _currentTab = 3;
  String _selectedLang = 'EN';

  Widget _exampleQuestion(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        context.read<ChatBloc>().add(
          SendChatMessageEvent(ChatParams(content: text)),
        );
        _textController.clear();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF22314A), width: 1.2),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: const Color(0xFF22314A),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 9, 43, 71),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(255, 9, 43, 71),
              ),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: Colors.white,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WorryMate",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 9, 43, 71),
              ),
            ),
            Text(
              "Your AI worry buddy",
              style: TextStyle(color: Colors.black, fontSize: 13),
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
                    _selectedLang = 'EN';
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(width: 1),
                    backgroundColor: _selectedLang == 'EN'
                        ? const Color.fromARGB(255, 9, 43, 71)
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'EN'
                        ? Colors.white
                        : const Color.fromARGB(255, 9, 43, 71),
                  ),
                  child: const Text('EN'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextButton(
                  onPressed: () {
                    _selectedLang = 'AM';
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(width: 1),
                    backgroundColor: _selectedLang == 'AM'
                        ? const Color.fromARGB(255, 9, 43, 71)
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'AM'
                        ? Colors.white
                        : const Color.fromARGB(255, 9, 43, 71),
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
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatCrisis) {
                  return const CrisisCard();
                } else if (state is ChatSuccess) {
                  return Center(
                    child: Text(
                      state.content ?? 'No content',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                // Initial state UI
                return SingleChildScrollView(
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
                          color: const Color(0xFF22314A),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
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
                              color: Colors.white,
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
                              color: Colors.black54,
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
                              context,
                              "I'm really stressed about my exams",
                            ),
                            _exampleQuestion(
                              context,
                              "I lost my job and i'm worried about money.",
                            ),
                            _exampleQuestion(
                              context,
                              "My family and i keep fighting.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input box at the bottom
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF22314A),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF22314A),
                          width: 2.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic, color: Color(0xFF22314A)),
                        onPressed: () {},
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        context.read<ChatBloc>().add(
                          SendChatMessageEvent(ChatParams(content: val.trim())),
                        );
                        _textController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF22314A)),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                        SendChatMessageEvent(ChatParams(content: text)),
                      );
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTab,
        onTap: (index) {
          // Handle navigation to different tabs
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1: // Journal
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2: // Offline pack
              Navigator.pushReplacementNamed(context, '/offlinetoolkit');
              break;
            case 3: // Chat (current screen)
              // Already on chat screen, do nothing
              break;
            case 4: // Settings
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
