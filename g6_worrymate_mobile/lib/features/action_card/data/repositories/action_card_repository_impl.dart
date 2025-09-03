import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/action_card_entity.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../datasources/action_card_remote_data_source.dart';

class ActionCardRepositoryImpl implements ActionCardRepository {
  final ActionCardRemoteDataSource remoteDataSource;

  ActionCardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActionCardEntity>> composeActionCard({
    required String topicKey,
    required Map<String, dynamic> block,
    required String language,
  }) async {
    try {
      final model = await remoteDataSource.composeActionCard(
        topicKey: topicKey,
        block: block,
        language: language,
      );
      print(
        ' i have successfuly recieved data from remote for action card: $model',
      );
      return Right(
        ActionCardEntity(
          title: model.title,
          description: model.description,
          steps: model.steps
              .map((step) => '${step.title}: ${step.description}')
              .toList(),

          miniTools: model.miniTools
              .map((e) => ToolLinkEntity(title: e.title, url: e.url))
              .toList(),
          ifWorse: model.ifWorse,
          disclaimer: model.disclaimer,
        ),
      );
    } catch (e) {
      print(
        'i havenot received data from remote this is the repo impl part: $e',
      );
      return Left(ServerFailure(error: e.toString()));
    }
  }
}
