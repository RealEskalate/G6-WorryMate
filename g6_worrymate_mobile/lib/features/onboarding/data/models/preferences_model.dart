import '../../../onboarding/domain/entities/app_preferences.dart';

class PreferencesModel extends AppPreferences {
  const PreferencesModel({
    required super.darkMode,
    required super.languageCode,
    required super.saveChat,
  });

  factory PreferencesModel.fromEntity(AppPreferences e) => PreferencesModel(
        darkMode: e.darkMode,
        languageCode: e.languageCode,
        saveChat: e.saveChat,
      );

  factory PreferencesModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return AppPreferences.defaults.toModel();
    return PreferencesModel(
      darkMode: map['darkMode'] as bool? ?? false,
      languageCode: map['languageCode'] as String? ?? 'en',
      saveChat: map['saveChat'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'darkMode': darkMode,
        'languageCode': languageCode,
        'saveChat': saveChat,
      };

  AppPreferences toEntity() => AppPreferences(
        darkMode: darkMode,
        languageCode: languageCode,
        saveChat: saveChat,
      );
}

extension _PrefsExt on AppPreferences {
  PreferencesModel toModel() =>
      PreferencesModel(darkMode: darkMode, languageCode: languageCode, saveChat: saveChat);
}