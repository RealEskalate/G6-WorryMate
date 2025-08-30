import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/connection/network_info.dart';
import 'core/databases/api/api_consumer.dart';
import 'core/databases/api/dio_consumer.dart';
import 'features/action_card/data/datasources/chat_local_data_source.dart';
import 'features/action_card/data/datasources/chat_remote_data_source.dart';
import 'features/action_card/data/repositories/chat_repository_impl.dart';
import 'features/action_card/domain/repositories/chat_repository.dart';
import 'features/action_card/domain/usecases/add_chat.dart';
import 'features/action_card/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() => ChatBloc(addChatUsecase: sl()));

  // Use case
  sl.registerLazySingleton(() => AddChatUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSource());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: Dio()));
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());
}
