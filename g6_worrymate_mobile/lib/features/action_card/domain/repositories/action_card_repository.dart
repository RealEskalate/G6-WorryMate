import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/action_card_entity.dart';

abstract class ActionCardRepository {
  Future<Either<Failure, ActionCardEntity>> composeActionCard({
    required String topicKey,
    required Map<String, dynamic> block,
    required String language,
  });
}