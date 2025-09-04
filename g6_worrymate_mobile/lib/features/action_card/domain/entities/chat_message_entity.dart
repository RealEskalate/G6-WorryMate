import 'action_card_entity.dart';

enum ChatSender { user, bot }

class ChatMessage {
  final String text;
  final ChatSender sender;
  final ActionCardEntity? actionCard;

  ChatMessage({required this.text, required this.sender, this.actionCard});
}
