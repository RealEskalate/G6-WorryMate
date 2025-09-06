import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';

abstract class NormalChatRepository {
Future<Either<Failure, String>> getNormalChat(ChatParams chat);
}