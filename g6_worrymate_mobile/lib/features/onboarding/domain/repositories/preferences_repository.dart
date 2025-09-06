import '../entities/app_preferences.dart';

abstract class PreferencesRepository {
  Future<AppPreferences> load();
  Future<void> save(AppPreferences prefs);
}