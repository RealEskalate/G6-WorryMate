import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../repositories/chat_repository.dart';

class AddChatUsecase {
  final ChatRepository repository;
  AddChatUsecase({required this.repository});
  Future<Either<Failure, int>> call(ChatParams chat) {
    return repository.addChat(chat);
  }
}

class GetTopicKeyUsecase{
  final ChatRepository repository;
  GetTopicKeyUsecase({required this.repository});

  Future<Either<Failure,String>> call(ChatParams chat){
    return repository.getTopicKey(chat);
  }
}