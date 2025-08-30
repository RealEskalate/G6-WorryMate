import '../../domain/usecases/add_chat.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AddChatUsecase addChatUsecase;

  ChatBloc({required this.addChatUsecase}) : super(ChatInitial()) {
    on<SendChatMessageEvent>(_onSendChatMessage);
  }

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final result = await addChatUsecase.call(event.params);
      
      result.fold(
        (failure) {
          emit(ChatError(failure.toString()));
        },
        (risk) {
          if (risk == 3) {
            emit(ChatCrisis());
          } else if (risk == 2 || risk == 1) {
            // Generate appropriate content based on risk level
            String content;
            if (risk == 2) {
              content = "I understand this is causing you significant stress. Let me help you with some coping strategies...";
            } else {
              content = "I hear you. Let's work through this together with some practical steps...";
            }
            emit(ChatSuccess(risk: risk, content: content));
          } else {
            emit(ChatError('Unexpected risk value: $risk'));
          }
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}