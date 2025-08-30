import '../../domain/entities/chat_entitiy.dart';

class ChatModel extends ChatEntity {
  ChatModel({required super.risk}) : super();

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(risk: json['risk'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'risk': risk};
  }
}
