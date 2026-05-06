import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../repositories/normal_chat_repository.dart';

class NormalChatUseCase {
  final NormalChatRepository repository;

  NormalChatUseCase(this.repository);

  Future<Either<Failure, String>> call(ChatParams params) async {
    return await repository.getNormalChat(params);
  }
}
