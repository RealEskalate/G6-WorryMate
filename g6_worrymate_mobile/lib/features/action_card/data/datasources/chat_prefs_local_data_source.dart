import 'package:hive/hive.dart';

class ChatPrefsLocalDataSource {
  static const String _boxName = 'settingsBox';
  static const String _saveKey = 'saveChatEnabled';

  Future<bool> isSaveEnabled() async {
    final box = await Hive.openBox(_boxName);
    return (box.get(_saveKey) as bool?) ?? false;
  }

  Future<void> setSaveEnabled(bool enabled) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_saveKey, enabled);
  }
}


