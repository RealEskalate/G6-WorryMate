import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

import 'action_card_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedLang = 'EN';
  final _controller = ChatMessagesController();
  final _currentUser = const ChatUser(id: 'user', firstName: 'User');
  final _aiUser = const ChatUser(id: 'ai', firstName: 'AI Assistant');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    setState(() => _selectedLang = 'EN');
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
                    setState(() => _selectedLang = 'AM');
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
            child: AiChatWidget(
              currentUser: _currentUser,
              aiUser: _aiUser,
              controller: _controller,
              onSendMessage: _handleSendMessage,
              loadingConfig: LoadingConfig(isLoading: _isLoading),

              messageOptions: MessageOptions(
                customBubbleBuilder: (context, message, isCurrentUser) {
                  if (!isCurrentUser) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ActionCardScreen(
                        
                      ),
                    );
                  }
                  // Fallback for user message bubble (simple default style)
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        message.text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),

              inputOptions: const InputOptions(
                containerDecoration: BoxDecoration(
                  color: Color(0xFFF7F7F8),
                  border: Border(
                    top: BorderSide(width: 1, color: Color(0xFFE7E7EA)),
                  ),
                ),
                containerBackgroundColor: Colors.transparent,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.mic_outlined, color: Colors.grey),
                  isDense: true,
                  hintText: 'Share what\'s on your mind...',
                  hintStyle: TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFE7E7EA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFE7E7EA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 20, 11, 43),
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                sendOnEnter: true,
              ),

              welcomeMessageConfig: const WelcomeMessageConfig(
                title: 'Welcome to WorryMate ',
                questionsSectionTitle: 'Try asking me:',
              ),
              exampleQuestions: const [
                ExampleQuestion(
                  question: "I'm really stressed about my exams ",
                ),
                ExampleQuestion(
                  question: "I lost my job and i'm worried about money.",
                ),
                ExampleQuestion(question: " My family and i keep fighting."),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            // color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ), // smaller padding
                    minimumSize: const Size(
                      0,
                      0,
                    ), // allows the button to shrink
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ), // or 8 for more roundness
                    ),

                    backgroundColor: const Color.fromARGB(255, 221, 219, 219),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Offline Ready",
                    style: TextStyle(
                      color: Color.fromARGB(255, 39, 20, 85),
                      fontSize: 11, // slightly smaller font
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "General wellbieng info, not medical advice",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.grey),
                    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/offline-tool');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.private_connectivity_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Offline Tools",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.grey),
                    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings_outlined, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        "Settings",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      _controller.addMessage(
        ChatMessage(
          text: "", // content rendered by custom bubble
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
