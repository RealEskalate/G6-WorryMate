import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_worrymate_mobile/features/crisis_card/presentation/pages/crisis_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/localization/locales.dart';

import '../../../../core/params/params.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'action_card_screen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  int _currentTab = 3;
  String _selectedLang = 'en';
  late FlutterLocalization _flutterLocalization;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _selectedLang = _flutterLocalization.currentLocale?.languageCode ?? 'en';
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatCrisis) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: CrisisCard(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF22314A),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1, color: const Color(0xFF22314A)),
              ),
              child: const Icon(Icons.favorite_border_rounded, color: Colors.white),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WorryMate',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF22314A),
                ),
              ),
              Text(
                LocalData.chatTagline.getString(context),
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
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
                      _flutterLocalization.translate('en');
                      setState(() => _selectedLang = 'en');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(width: 1, color: Color(0xFF22314A)),
                      backgroundColor: _selectedLang == 'en'
                          ? const Color(0xFF22314A)
                          : Colors.transparent,
                      foregroundColor: _selectedLang == 'en'
                          ? Colors.white
                          : const Color(0xFF22314A),
                    ),
                    child: const Text('EN'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextButton(
                    onPressed: () {
                      _flutterLocalization.translate('am');
                      setState(() => _selectedLang = 'am');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(width: 1, color: Color(0xFF22314A)),
                      backgroundColor: _selectedLang == 'am'
                          ? const Color(0xFF22314A)
                          : Colors.transparent,
                      foregroundColor: _selectedLang == 'am'
                          ? Colors.white
                          : const Color(0xFF22314A),
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
                    LocalData.chatTryAsking.getString(context),
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _exampleQuestion(
                    context,
                    LocalData.chatExampleStressedExams.getString(context),
                  ),
                  _exampleQuestion(
                    context,
                    LocalData.chatExampleLostJob.getString(context),
                  ),
                  _exampleQuestion(context, LocalData.chatExampleFamilyFighting.getString(context)),
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: LocalData.chatInputHint.getString(context),
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
                            SendChatMessageEvent(
                              ChatParams(content: val.trim()),
                            ),
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
            setState(() {
              _currentTab = index;
            });
            switch (index) {
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
      ),
    );
  }
}
