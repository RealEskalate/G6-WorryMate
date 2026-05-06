import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';

abstract class ChatRepository {
  Future<Either<Failure, int>> addChat(ChatParams chat);
  Future<Either<Failure, String>> getTopicKey(ChatParams chat);
}
