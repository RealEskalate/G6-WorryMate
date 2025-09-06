import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:g6_worrymate_mobile/features/crisis_card/presentation/pages/crisis_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String selectedOption = 'vent';
  List<String> selectOptions = ['vent', 'seek advice'];

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _selectedLang = _flutterLocalization.currentLocale?.languageCode ?? 'en';
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatBloc>().add(LoadChatTranscriptEvent());
      }
    });
  }

  @override
  void dispose() {
    // Attempt to persist current transcript when leaving the screen
    if (mounted) {
      try {
        context.read<ChatBloc>().add(SaveChatTranscriptEvent());
      } catch (_) {}
    }
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onMicPressed() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (s) {
          if (s == 'done' || s == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (e) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Speech error: ${e.errorMsg}')),
          );
        },
      );
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          localeId: _selectedLang == 'am' ? 'am_ET' : 'en_US',
          onResult: (res) {
            setState(() {
              _textController.text = res.recognizedWords;
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textController.text.length),
              );
            });
          },
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    } else {
      await _speech.stop();
      setState(() => _isListening = false);
    }
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
            SendChatMessageEvent(
              ChatParams(content: text),
              _selectedLang,
              selectedOption,
            ),
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
    final promptFromHomePage =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (promptFromHomePage != null && _textController.text.isEmpty) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/logo1.jpg',
                  fit: BoxFit.cover,
                ),
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
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'en') {
                  _flutterLocalization.translate('en');
                } else {
                  _flutterLocalization.translate('am');
                }
                setState(() => _selectedLang = value);
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      const Text('EN'),
                      if (_selectedLang == 'en')
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, size: 18),
                        ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'am',
                  child: Row(
                    children: [
                      const Text('አማ'),
                      if (_selectedLang == 'am')
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, size: 18),
                        ),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.08)
                      : const Color(0xFFE0E7EF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.greenAccent
                        : const Color(0xFF22314A),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedLang == 'en' ? 'EN' : 'አማ',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF22314A),
                        fontSize: 14,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
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
                    return const UpgradeToPremiumCard(); //   child: Padding(
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
                          vertical: 23,
                        ),
                        fillColor: getInputBackgroundColor(),
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 4),
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'vent',
                                child: Text('Vent'),
                              ),
                              const PopupMenuItem(
                                value: 'seek advice',
                                child: Text('Seek Advice'),
                              ),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.08)
                                    : const Color(0xFFE0E7EF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.greenAccent
                                      : const Color(0xFF22314A),
                                  // width: ,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedOption == 'vent'
                                        ? 'Vent'
                                        : 'Seek Advice',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF22314A),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening
                                ? Colors.redAccent
                                : getPrimaryColor(),
                          ),
                          onPressed: _onMicPressed,
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
                              selectedOption,
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
                            selectedOption,
                          ),
                        );
                        _textController.clear();
                        // Opportunistic auto-save after each send
                        context.read<ChatBloc>().add(SaveChatTranscriptEvent());
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
