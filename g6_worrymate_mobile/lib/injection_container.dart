import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/connection/network_info.dart';
import 'core/databases/api/api_consumer.dart';
import 'core/databases/api/dio_consumer.dart';
import 'features/action_card/data/datasources/action_block_remote_datasource.dart';
import 'features/action_card/data/datasources/action_card_local_dat_source.dart';
import 'features/action_card/data/datasources/action_card_remote_data_source.dart';
import 'features/action_card/data/datasources/chat_local_data_source.dart';
import 'features/action_card/data/datasources/chat_prefs_local_data_source.dart';
import 'features/action_card/data/datasources/chat_remote_data_source.dart';
import 'features/action_card/data/repositories/action_block_repository_impl.dart';
import 'features/action_card/data/repositories/action_card_repository_impl.dart';
import 'features/action_card/data/repositories/chat_repository_impl.dart';
import 'features/action_card/domain/repositories/action_block_repository.dart';
import 'features/action_card/domain/repositories/action_card_repository.dart';
import 'features/action_card/domain/repositories/chat_repository.dart';
import 'features/action_card/domain/usecases/action_block_usecase.dart';
import 'features/action_card/domain/usecases/action_card_usecase.dart';
import 'features/action_card/domain/usecases/add_chat.dart';
import 'features/action_card/presentation/bloc/chat_bloc.dart';
import 'features/activity_tracking/data/datasources/activity_local_data_soruce.dart';
import 'features/activity_tracking/data/models/activity_day_model.dart';
import 'features/activity_tracking/data/repositories/activity_repository_impl.dart';
import 'features/activity_tracking/domain/repositories/activity_repository.dart';
import 'features/activity_tracking/domain/usecases/compute_streak_use_case.dart';
import 'features/activity_tracking/domain/usecases/get_last_n_days_use_case.dart';
import 'features/activity_tracking/domain/usecases/log_activity_use_case.dart';
import 'features/activity_tracking/domain/usecases/log_mood_use_case.dart';
import 'features/activity_tracking/presentation/cubit/activity_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ActivityDayModelAdapter());
  }

  sl.registerLazySingleton<ActivityLocalDataSource>(
      () => ActivityLocalDataSourceImpl());
  sl.registerLazySingleton<ActivityRepository>(
      () => ActivityRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LogActivityUseCase(sl()));
  sl.registerLazySingleton(() => LogMoodUseCase(sl()));
  sl.registerLazySingleton(() => GetLastNDaysUseCase(sl()));
  sl.registerLazySingleton(() => ComputeStreakUseCase(sl()));

  // Cubit
  sl.registerFactory(() => ActivityCubit(
        sl<LogActivityUseCase>(),
        sl<LogMoodUseCase>(),
        sl<GetLastNDaysUseCase>(),
        sl<ComputeStreakUseCase>(),
      ));



  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      getTopicKeyUsecase: sl(),
      getActionBlockUsecase: sl(),
      addChatUsecase: sl(),
      composeActionCardUsecase: sl(),
      chatLocalDataSource: sl(),
      chatPrefsLocalDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddChatUsecase(repository: sl()));
  sl.registerLazySingleton<GetTopicKeyUsecase>(
    () => GetTopicKeyUsecase(repository: sl()),
  );
  sl.registerLazySingleton<GetActionBlockUsecase>(
    () => GetActionBlockUsecase(sl()),
  );
  sl.registerLazySingleton<ComposeActionCardUsecase>(
    () => ComposeActionCardUsecase(sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ActionBlockRepository>(
    () => ActionBlockRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ActionCardRepository>(
    () => ActionCardRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSource());
  sl.registerLazySingleton<ActionCardLocalDataSource>(
    () => ActionCardLocalDataSource(),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSource(),
  );
  sl.registerLazySingleton<ChatPrefsLocalDataSource>(
    () => ChatPrefsLocalDataSource(),
  );
  sl.registerLazySingleton<ActionBlockRemoteDataSource>(
    () => ActionBlockRemoteDataSource(),
  );
  sl.registerLazySingleton<ActionCardRemoteDataSource>(
    () => ActionCardRemoteDataSource(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: Dio()));
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
}
