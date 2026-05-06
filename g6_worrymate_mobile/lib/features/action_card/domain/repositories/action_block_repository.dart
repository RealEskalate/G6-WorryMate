import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/action_block_entity.dart';


abstract class ActionBlockRepository {
  Future<Either<Failure, ActionBlockEntity>> getActionBlock(String topicKey, String lang);
}