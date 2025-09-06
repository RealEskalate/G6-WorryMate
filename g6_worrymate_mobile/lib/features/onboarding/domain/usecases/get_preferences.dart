import '../entities/app_preferences.dart';
import '../repositories/preferences_repository.dart';

class GetPreferences {
  final PreferencesRepository repo;
  GetPreferences(this.repo);

  Future<AppPreferences> call() => repo.load();
}