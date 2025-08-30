
import '../../../../core/params/params.dart';

class ChatEvent {}

class ChatExampleQuestionEvent extends ChatEvent{

}

class SendChatMessageEvent extends ChatEvent{
  final ChatParams params;
  SendChatMessageEvent( this.params);
}


