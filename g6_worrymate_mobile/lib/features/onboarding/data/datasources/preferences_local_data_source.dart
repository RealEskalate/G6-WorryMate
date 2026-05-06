import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences_model.dart';
import '../../../onboarding/domain/entities/app_preferences.dart';

abstract class PreferencesLocalDataSource {
  Future<PreferencesModel> load();
  Future<void> save(AppPreferences prefs);
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  static const _key = 'app_preferences_v1';

  final SharedPreferences prefs;
  PreferencesLocalDataSourceImpl(this.prefs);

  @override
  Future<PreferencesModel> load() async {
    final raw = prefs.getString(_key);
    if (raw == null) return PreferencesModel.fromEntity(AppPreferences.defaults);
    try {
      return PreferencesModel.fromMap(jsonDecode(raw));
    } catch (_) {
      return PreferencesModel.fromEntity(AppPreferences.defaults);
    }
  }

  @override
  Future<void> save(AppPreferences p) async {
    final model = PreferencesModel.fromEntity(p);
    await prefs.setString(_key, jsonEncode(model.toMap()));
  }
}