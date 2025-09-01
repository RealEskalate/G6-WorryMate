import 'package:flutter_bloc/flutter_bloc.dart';

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
  }) : super(ChatInitial()) {
    on<SendChatMessageEvent>(_onSendChatMessage);
  }

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final result = await addChatUsecase.call(event.params);
      await result.fold(
        (failure) async {
          emit(ChatError(failure.toString()));
        },
        (risk) async {
          if (risk == 3) {
            emit(ChatCrisis());
          }

          else if (risk == 2 || risk == 1) {
            final topicKeyResult = await getTopicKeyUsecase.call(event.params);
            await topicKeyResult.fold(
              (failure) async {
                emit(ChatError(failure.toString()));
              },
              (topicKey) async {
                final lang = 'en'; // or get from event/params
                final actionBlockResult = await getActionBlockUsecase.call(
                  topicKey,
                  lang,
                );
                await actionBlockResult.fold(
                  (failure) async {
                    emit(ChatError(failure.toString()));
                  },
                  (actionBlock) async {
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
                      (failure) => emit(ChatError(failure.toString())),
                      (actionCard) => emit(
                        ChatSuccess(risk: risk, actionCard: actionCard),
                      ), // or pass the whole entity
                    );
                  },
                );
              },
            );
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
