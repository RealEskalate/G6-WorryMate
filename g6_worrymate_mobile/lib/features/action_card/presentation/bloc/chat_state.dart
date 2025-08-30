
abstract class ChatState {}

class ChatInitial extends ChatState{}

class ChatLoading extends ChatState{}

class ChatSuccess extends ChatState {
  final int risk;
  final String? content;
  ChatSuccess({
    required this.risk,
    required this.content
  });
}

class ChatCrisis extends ChatState {} // For risk == 3

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}