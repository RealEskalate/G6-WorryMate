import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../domain/repositories/normal_chat_repository.dart';
import '../datasources/normal_chat_remote_data_source.dart';


class NormalChatRepositoryImpl implements NormalChatRepository {
  final NormalChatRemoteDataSource normalChatRemoteDataSource;

  NormalChatRepositoryImpl({required this.normalChatRemoteDataSource});

  @override
  Future<Either<Failure, String>> getNormalChat(ChatParams chat) async {
    try {
      final result = await normalChatRemoteDataSource.getNormalChat(chat);
      return Right(result as String);
    } catch (e) {
      return Left(ServerFailure(error:  e.toString()));
    }
  }
}