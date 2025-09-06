class AppPreferences {
  final bool darkMode;
  final String languageCode; // e.g. 'en', 'am'
  final bool saveChat;

  const AppPreferences({
    required this.darkMode,
    required this.languageCode,
    required this.saveChat,
  });

  AppPreferences copyWith({
    bool? darkMode,
    String? languageCode,
    bool? saveChat,
  }) => AppPreferences(
        darkMode: darkMode ?? this.darkMode,
        languageCode: languageCode ?? this.languageCode,
        saveChat: saveChat ?? this.saveChat,
      );

  static const AppPreferences defaults =
      AppPreferences(darkMode: false, languageCode: 'en', saveChat: true);
}