import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/params/params.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'action_card_screen.dart';

class ChatScreen extends StatelessWidget {
  Widget _exampleQuestion(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          context.read<ChatBloc>().add(
            SendChatMessageEvent(ChatParams(content: text)),
          );
          _textController.clear();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7EF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF22314A), width: 1),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFF22314A),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  ChatScreen({Key? key}) : super(key: key);
  final TextEditingController _textController = TextEditingController();
  final int _currentTab = 3;
  String _selectedLang = 'EN';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8FAFC), // light background
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF22314A), // primary color
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1, color: Color(0xFF22314A)),
            ),
            child: Icon(Icons.favorite_border_rounded, color: Colors.white),
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
                color: Color(0xFF22314A), // text color
              ),
            ),
            Text(
              "Your AI worry buddy",
              style: TextStyle(
                color: Color(0xFF6B7280), // subtitle color
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
                    // No setState in StatelessWidget, so just ignore for now
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 1, color: Color(0xFF22314A)),
                    backgroundColor: _selectedLang == 'EN'
                        ? Color(0xFF22314A)
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'EN'
                        ? Colors.white
                        : Color(0xFF22314A),
                  ),
                  child: const Text('EN'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextButton(
                  onPressed: () {
                    // No setState in StatelessWidget, so just ignore for now
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 1, color: Color(0xFF22314A)),
                    backgroundColor: _selectedLang == 'AM'
                        ? Color(0xFF22314A)
                        : Colors.transparent,
                    foregroundColor: _selectedLang == 'AM'
                        ? Colors.white
                        : Color(0xFF22314A),
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
          // Example questions section
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try asking about:',
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                _exampleQuestion(context, "I'm really stressed about my exams"),
                _exampleQuestion(
                  context,
                  "I lost my job and i'm worried about money.",
                ),
                _exampleQuestion(context, "My family and i keep fighting."),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final messages = state.messages;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    if (msg.sender == ChatSender.user) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22314A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    } else if (msg.actionCard != null) {
                      return ActionCardWidget(actionCard: msg.actionCard!);
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe0e7ef),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg.text,
                            style: const TextStyle(
                              color: Color(0xFF22314A),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }
                  },
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
