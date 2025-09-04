import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../data/datasources/chat_local_data_source.dart';
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
  final ChatLocalDataSource chatLocalDataSource;

  ChatBloc({
    required this.composeActionCardUsecase,
    required this.addChatUsecase,
    required this.getActionBlockUsecase,
    required this.getTopicKeyUsecase,
    required this.chatLocalDataSource,
  }) : super(const ChatInitial()) {
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<SaveChatTranscriptEvent>(_onSaveTranscript);
    on<LoadChatTranscriptEvent>(_onLoadTranscript);
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
          emit(
            ChatError('cannot get risk from APi', messages: currentMessages),
          );
        },
        (risk) async {
          if (risk == 3) {
            // Persist crisis event with the triggering user message
            await chatLocalDataSource.saveCrisis(
              userText: event.params.content,
            );
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


                final lang = event.language;

                final actionBlockResult = await getActionBlockUsecase.call(
                  topicKey,
                  lang,
                );
                await actionBlockResult.fold(
                  (failure) async {
                    emit(
                      ChatError(
                        'The server is busy or not responding. Please wait a moment and try again. 429 error',
                        messages: currentMessages,
                      ),
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
                    await composeResult.fold(
                      (failure) async {
                        emit(
                          ChatError(
                            failure.toString(),
                            messages: currentMessages,
                          ),
                        );
                      },
                      (actionCard) async {
                        // Persist action card with the user's prompt
                        await chatLocalDataSource.saveActionCardWithPrompt(
                          userText: event.params.content,
                          actionCard: actionCard,
                        );
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



  

  Future<void> _onSaveTranscript(
    SaveChatTranscriptEvent event,
    Emitter<ChatState> emit,
  ) async {
    final currentMessages = List<ChatMessage>.from(state.messages);
    try {
      await chatLocalDataSource.saveTranscript(messages: currentMessages);
      emit(ChatSuccess(risk: state is ChatSuccess ? (state as ChatSuccess).risk : 0, messages: currentMessages));
    } catch (e) {
      emit(ChatError(e.toString(), messages: currentMessages));
    }
  }
  
  Future<void> _onLoadTranscript(
    LoadChatTranscriptEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final loaded = await chatLocalDataSource.loadLastTranscript();
      if (loaded.isNotEmpty) {
        emit(ChatSuccess(risk: 0, messages: loaded));
      }
    } catch (_) {
      // ignore load errors silently
    }
  }
}
