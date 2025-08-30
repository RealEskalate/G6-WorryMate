

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/chat_entitiy.dart';

abstract class ChatRepository {

Future<Either<Failure, int>> addChat(ChatParams chat);

}
