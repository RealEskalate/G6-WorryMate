import 'package:hive/hive.dart';

import '../../domain/entities/action_card_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatLocalDataSource {
  static const String crisisBoxName = 'crisisEventsBox';
  static const String actionHistoryBoxName = 'actionHistoryBox';
  static const String transcriptBoxName = 'chatTranscriptsBox';

  Future<void> saveCrisis({
    required String userText,
    DateTime? at,
  }) async {
    final box = await Hive.openBox(crisisBoxName);
    await box.add({
      'userText': userText,
      'timestamp': (at ?? DateTime.now()).toIso8601String(),
    });
  }

  Future<void> saveActionCardWithPrompt({
    required String userText,
    required ActionCardEntity actionCard,
    DateTime? at,
  }) async {
    final box = await Hive.openBox(actionHistoryBoxName);
    await box.add({
      'userText': userText,
      'timestamp': (at ?? DateTime.now()).toIso8601String(),
      'actionCard': {
        'title': actionCard.title,
        'description': actionCard.description,
        'steps': actionCard.steps,
        'miniTools': actionCard.miniTools
            .map((e) => {'title': e.title, 'url': e.url})
            .toList(),
        'uiTools': actionCard.uiTools,
        'ifWorse': actionCard.ifWorse,
        'disclaimer': actionCard.disclaimer,
      },
    });
  }

  Future<void> saveTranscript({
    required List<ChatMessage> messages,
    DateTime? at,
  }) async {
    final box = await Hive.openBox(transcriptBoxName);
    await box.add({
      'timestamp': (at ?? DateTime.now()).toIso8601String(),
      'messages': messages
          .map((m) => {
                'text': m.text,
                'sender': m.sender.name,
                'actionCard': m.actionCard == null
                    ? null
                    : {
                        'title': m.actionCard!.title,
                        'description': m.actionCard!.description,
                        'steps': m.actionCard!.steps,
                        'miniTools': m.actionCard!.miniTools
                            .map((e) => {'title': e.title, 'url': e.url})
                            .toList(),
                        'uiTools': m.actionCard!.uiTools,
                        'ifWorse': m.actionCard!.ifWorse,
                        'disclaimer': m.actionCard!.disclaimer,
                      },
              })
          .toList(),
    });
  }

  Future<List<ChatMessage>> loadLastTranscript() async {
    final box = await Hive.openBox(transcriptBoxName);
    if (box.isEmpty) return [];
    final Map<dynamic, dynamic> last = box.getAt(box.length - 1);
    final List<dynamic> rawMessages = (last['messages'] as List?) ?? [];
    return rawMessages.map((raw) {
      final Map<String, dynamic> m = Map<String, dynamic>.from(raw);
      final action = m['actionCard'];
      return ChatMessage(
        text: m['text'] ?? '',
        sender: (m['sender'] == 'bot') ? ChatSender.bot : ChatSender.user,
        actionCard: action == null
            ? null
            : ActionCardEntity(
                title: action['title'] ?? '',
                description: action['description'] ?? '',
                steps: List<String>.from(action['steps'] ?? []),
                miniTools: ((action['miniTools'] as List?) ?? [])
                    .map((e) => ToolLinkEntity(
                          title: e['title'] ?? '',
                          url: e['url'] ?? '',
                        ))
                    .toList(),
                uiTools: List<String>.from(action['uiTools'] ?? []),
                ifWorse: action['ifWorse'] ?? '',
                disclaimer: action['disclaimer'] ?? '',
              ),
      );
    }).toList();
  }

  Future<void> clearAllChatData() async {
    final crisis = await Hive.openBox(crisisBoxName);
    final actions = await Hive.openBox(actionHistoryBoxName);
    final transcripts = await Hive.openBox(transcriptBoxName);
    await Future.wait([
      crisis.clear(),
      actions.clear(),
      transcripts.clear(),
    ]);
  }
}


