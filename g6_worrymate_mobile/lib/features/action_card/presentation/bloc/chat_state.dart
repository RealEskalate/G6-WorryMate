import '../../domain/entities/action_card_entity.dart';


abstract class ChatState {}

class ChatInitial extends ChatState{}

class ChatLoading extends ChatState{}

class ChatSuccess extends ChatState {
  final int risk;
  final ActionCardEntity actionCard; // or whatever your entity/model is called

  ChatSuccess({required this.risk, required this.actionCard});
}

class ChatCrisis extends ChatState {} // For risk == 3

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}