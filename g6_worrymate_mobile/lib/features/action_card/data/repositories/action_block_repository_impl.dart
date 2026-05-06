import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/action_block_entity.dart';
import '../../domain/repositories/action_block_repository.dart';
import '../datasources/action_block_remote_datasource.dart';

class ActionBlockRepositoryImpl implements ActionBlockRepository {
  final ActionBlockRemoteDataSource remoteDataSource;

  ActionBlockRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActionBlockEntity>> getActionBlock(
    String topicKey,
    String lang,
  ) async {
    try {
      final model = await remoteDataSource.getActionBlock(topicKey, lang);
      print("got the action block from remote datasource: $model");
      final actionBlock = model.actionBlock;
      final block = actionBlock.block;
      return Right(
        ActionBlockEntity(
          topicKey: actionBlock.topicKey,
          language: actionBlock.language,
          empathyOpeners: block.empathyOpeners,
          microSteps: block.microSteps,
          scripts: block.scripts,
          toolLinks: block.toolLinks
              .map((tl) => ToolLinkEntity(title: tl.title, url: tl.url))
              .toList(),
          ifWorse: block.ifWorse,
          disclaimer: block.disclaimer,
        ),
      );
    } catch (e) {
      print("failed to get action block from remote: $e");
      return Left(ServerFailure(error: e.toString()));
    }
  }
}
