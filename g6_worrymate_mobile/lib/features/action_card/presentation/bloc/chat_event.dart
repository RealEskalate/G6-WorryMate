
import '../../../../core/params/params.dart';

class ChatEvent {}

class ChatExampleQuestionEvent extends ChatEvent{

}

class SendChatMessageEvent extends ChatEvent{
  final ChatParams params;
  final String language;
  final String option;
  SendChatMessageEvent(this.params, this.language, this.option);
}

class SaveChatTranscriptEvent extends ChatEvent {}

class LoadChatTranscriptEvent extends ChatEvent {}

class DeleteAllChatHistoryEvent extends ChatEvent {}


