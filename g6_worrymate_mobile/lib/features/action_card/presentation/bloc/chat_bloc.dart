import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/action_block_usecase.dart';
import '../../domain/usecases/action_card_usecase.dart';
import '../../domain/usecases/add_chat.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AddChatUsecase addChatUsecase;
  final GetTopicKeyUsecase getTopicKeyUsecase;
  final GetActionBlockUsecase getActionBlockUsecase;
  final ComposeActionCardUsecase composeActionCardUsecase;

  ChatBloc({
    required this.composeActionCardUsecase,
    required this.addChatUsecase,
    required this.getActionBlockUsecase,
    required this.getTopicKeyUsecase,
  }) : super(const ChatInitial()) {
    on<SendChatMessageEvent>(_onSendChatMessage);
  }

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final currentMessages = List<ChatMessage>.from(state.messages);
    currentMessages.add(
      ChatMessage(text: event.params.content, sender: ChatSender.user),
    );
    emit(ChatLoading(messages: currentMessages));
    try {
      final result = await addChatUsecase.call(event.params);
      await result.fold(
        (failure) async {
          emit(ChatError(failure.toString(), messages: currentMessages));
        },
        (risk) async {
          if (risk == 3) {
            emit(ChatCrisis(messages: currentMessages));
            return;
          } else if (risk == 2 || risk == 1) {
            emit(ChatLoading(messages: currentMessages));
            final topicKeyResult = await getTopicKeyUsecase.call(event.params);
            await topicKeyResult.fold(
              (failure) async {
                emit(ChatError(failure.toString(), messages: currentMessages));
              },
              (topicKey) async {
                emit(ChatLoading(messages: currentMessages));
                final lang = 'am';
                final actionBlockResult = await getActionBlockUsecase.call(
                  topicKey,
                  lang,
                );
                await actionBlockResult.fold(
                  (failure) async {
                    emit(
                      ChatError(failure.toString(), messages: currentMessages),
                    );
                  },
                  (actionBlock) async {
                    emit(ChatLoading(messages: currentMessages));
                    final composeResult = await composeActionCardUsecase.call(
                      topicKey: topicKey,
                      block: {
                        'empathy_openers': actionBlock.empathyOpeners,
                        'micro_steps': actionBlock.microSteps,
                        'scripts': actionBlock.scripts,
                        'tool_links': actionBlock.toolLinks
                            .map((e) => {'title': e.title, 'url': e.url})
                            .toList(),
                        'if_worse': actionBlock.ifWorse,
                        'disclaimer': actionBlock.disclaimer,
                      },
                      language: lang,
                    );
                    composeResult.fold(
                      (failure) => emit(
                        ChatError(
                          failure.toString(),
                          messages: currentMessages,
                        ),
                      ),
                      (actionCard) {
                        currentMessages.add(
                          ChatMessage(
                            text: 'Here is an action card for you.',
                            sender: ChatSender.bot,
                            actionCard: actionCard,
                          ),
                        );
                        emit(
                          ChatSuccess(risk: risk, messages: currentMessages),
                        );
                      },
                    );
                  },
                );
              },
            );
          } else {
            emit(
              ChatError(
                'Unexpected risk value: $risk',
                messages: currentMessages,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(ChatError(e.toString(), messages: currentMessages));
    }
  }
}
