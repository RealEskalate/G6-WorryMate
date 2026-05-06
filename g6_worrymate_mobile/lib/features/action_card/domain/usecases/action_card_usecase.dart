import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/action_card_entity.dart';
import '../repositories/action_card_repository.dart';

class ComposeActionCardUsecase {
  final ActionCardRepository repository;

  ComposeActionCardUsecase(this.repository);

  Future<Either<Failure, ActionCardEntity>> call({
    required String topicKey,
    required Map<String, dynamic> block,
    required String language,
  }) {
    return repository.composeActionCard(
      topicKey: topicKey,
      block: block,
      language: language,
    );
  }
}