import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:g6_worrymate_mobile/features/crisis_card/presentation/pages/crisis_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/locales.dart';
import '../../../../core/params/params.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/typing_indicator.dart';
import 'action_card_screen.dart';
import 'upgrade_to_premium_card.dart';

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
  bool _hasSentFirstPrompt = false;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _selectedLang = _flutterLocalization.currentLocale?.languageCode ?? 'en';
  }

  Widget _exampleQuestion(BuildContext context, String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _hasSentFirstPrompt = true;
          });
          context.read<ChatBloc>().add(
            SendChatMessageEvent(ChatParams(content: text), _selectedLang),
          );
          _textController.clear();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFE0E7EF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? Colors.greenAccent : const Color(0xFF22314A),
              width: 1,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);
    final isDarkMode = themeManager.isDarkMode;
    final promptFromHomePage = ModalRoute.of(context)?.settings.arguments as String?;
    if (promptFromHomePage != null && _textController.text.isEmpty){
      _textController.text = promptFromHomePage;
    }
    Color getBackgroundColor() => isDarkMode
        ? const Color.fromARGB(255, 9, 43, 71)
        : const Color(0xFFF8FAFC);

    Color getPrimaryColor() =>
        isDarkMode ? Colors.greenAccent : const Color(0xFF22314A);

    Color getTextColor() => isDarkMode ? Colors.white : Colors.black;

    Color getSubtitleColor() =>
        isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    Color getInputBorderColor() =>
        isDarkMode ? Colors.greenAccent : const Color(0xFF22314A);

    Color getInputBackgroundColor() =>
        isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white;

    Color getHintColor() => isDarkMode ? Colors.white60 : Colors.grey[600]!;
    // final promptFromHomePage = ModalRoute.of(context)?.settings.arguments;
    if (promptFromHomePage is String && _textController.text.isEmpty) {
      _textController.text = promptFromHomePage;
    }

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
                border: Border.all(width: 1, color: getPrimaryColor()),
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
                'WorryMate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: getTextColor(),
                ),
              ),
              Text(
                LocalData.chatTagline.getString(context),
                style: TextStyle(color: getSubtitleColor(), fontSize: 13),
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
                      side: BorderSide(width: 1, color: getPrimaryColor()),
                      backgroundColor: _selectedLang == 'en'
                          ? getPrimaryColor()
                          : Colors.transparent,
                      foregroundColor: _selectedLang == 'en'
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
                      _flutterLocalization.translate('am');
                      setState(() => _selectedLang = 'am');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(width: 1, color: getPrimaryColor()),
                      backgroundColor: _selectedLang == 'am'
                          ? getPrimaryColor()
                          : Colors.transparent,
                      foregroundColor: _selectedLang == 'am'
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
                      color: getSubtitleColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (!_hasSentFirstPrompt) ...[
                    _exampleQuestion(
                      context,
                      LocalData.chatExampleStressedExams.getString(context),
                      isDarkMode,
                    ),
                    _exampleQuestion(
                      context,
                      LocalData.chatExampleLostJob.getString(context),
                      isDarkMode,
                    ),
                    _exampleQuestion(
                      context,
                      LocalData.chatExampleFamilyFighting.getString(context),
                      isDarkMode,
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatError) {
                    // return Center(
                    return const UpgradeToPremiumCard(); //   child: Padding(
                    //     padding: const EdgeInsets.all(24.0),
                    //     child: Text(
                    //       state.message.isNotEmpty
                    //           ? state.message
                    //           : 'Server busy. Please try again later.',
                    //       style: const TextStyle(
                    //         color: Colors.red,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // );
                  }

                  final messages = state.messages;
                  final isLoading = state is ChatLoading;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    itemCount: isLoading
                        ? messages.length + 1
                        : messages.length,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
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
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.15)
                                    : const Color(0xFFe0e7ef),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF22314A),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        }
                      } else {
                        // Show typing indicator at the end if loading
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: TypingIndicator(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            Container(
              color: getBackgroundColor(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: LocalData.chatInputHint.getString(context),
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
                        if (val.trim().isNotEmpty) {
                          setState(() {
                            _hasSentFirstPrompt = true;
                          });
                          context.read<ChatBloc>().add(
                            SendChatMessageEvent(
                              ChatParams(content: val.trim()),
                              _selectedLang,
                            ),
                          );
                          _textController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: getPrimaryColor()),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          _hasSentFirstPrompt = true;
                        });
                        context.read<ChatBloc>().add(
                          SendChatMessageEvent(
                            ChatParams(content: text),
                            _selectedLang,
                          ),
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
