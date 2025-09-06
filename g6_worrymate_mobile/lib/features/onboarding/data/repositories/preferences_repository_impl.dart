import '../../domain/entities/app_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../datasources/preferences_local_data_source.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesLocalDataSource local;
  PreferencesRepositoryImpl(this.local);

  @override
  Future<AppPreferences> load() => local.load().then((m) => m.toEntity());

  @override
  Future<void> save(AppPreferences prefs) => local.save(prefs);
}