import '../entities/app_preferences.dart';
import '../repositories/preferences_repository.dart';

class SavePreferences {
  final PreferencesRepository repo;
  SavePreferences(this.repo);

  Future<void> call(AppPreferences p) => repo.save(p);
}