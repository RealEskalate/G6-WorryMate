import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/action_block_entity.dart';
import '../repositories/action_block_repository.dart';


class GetActionBlockUsecase {
  final ActionBlockRepository repository;

  GetActionBlockUsecase(this.repository);

  Future<Either<Failure, ActionBlockEntity>> call(String topicKey, String lang) {
    return repository.getActionBlock(topicKey, lang);
  }
}