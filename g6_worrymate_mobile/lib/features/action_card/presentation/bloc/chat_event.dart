
import '../../../../core/params/params.dart';

class ChatEvent {}

class ChatExampleQuestionEvent extends ChatEvent{

}

class SendChatMessageEvent extends ChatEvent{
  final ChatParams params;
  final String language;
  SendChatMessageEvent( this.params, this.language);
}


