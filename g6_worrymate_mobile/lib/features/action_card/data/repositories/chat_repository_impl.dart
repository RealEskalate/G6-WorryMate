import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/action_card_local_dat_source.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ActionCardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({required this.localDataSource,
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, int>> addChat(ChatParams params) async {
    try {
      print(
        '[ChatRepositoryImpl] addChat called with params: ' + params.toString(),
      );
      final risk = await remoteDataSource.addChat(params);
      print(
        '[ChatRepositoryImpl] Received risk from remoteDataSource: ' +
            risk.toString(),
      );
      if (risk == 3) {
        print('[ChatRepositoryImpl] Risk is 3 (highest)');
        return Right(risk);
      } else if (risk == 2 || risk == 1) {
        print('[ChatRepositoryImpl] Risk is 2 or 1 (medium/low)');
        return Right(risk);
      } else {
        print('[ChatRepositoryImpl] Error: Risk value is not a valid int');
        return Left(ServerFailure(error: "Risk value is not a valid int"));
      }
    } catch (e, stack) {
      print('[ChatRepositoryImpl] Exception: ' + e.toString());
      print(stack);
      return Left(ServerFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTopicKey(ChatParams chat) async {
    try {
      final topicKey = await remoteDataSource.getTopicKey(chat);
      print("repo level topic key: $topicKey");
      return Right(topicKey);
    } catch (e, stack) {
      print('[ChatRepositoryImpl] Exception in getTopicKey: ' + e.toString());
      print(stack);
      return Left(ServerFailure(error: e.toString()));
    }
  }

}
