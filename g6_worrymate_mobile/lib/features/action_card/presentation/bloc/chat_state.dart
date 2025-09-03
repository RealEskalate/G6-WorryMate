import '../../domain/entities/chat_message_entity.dart';

abstract class ChatState {
  final List<ChatMessage> messages;
  const ChatState({this.messages = const []});
}

class ChatInitial extends ChatState {
  const ChatInitial() : super(messages: const []);
}

class ChatLoading extends ChatState {
  const ChatLoading({List<ChatMessage> messages = const []})
    : super(messages: messages);
}

class ChatSuccess extends ChatState {
  final int risk;
  const ChatSuccess({required this.risk, required List<ChatMessage> messages})
    : super(messages: messages);
}

class ChatCrisis extends ChatState {
  const ChatCrisis({List<ChatMessage> messages = const []})
    : super(messages: messages);
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message, {List<ChatMessage> messages = const []})
    : super(messages: messages);
}
