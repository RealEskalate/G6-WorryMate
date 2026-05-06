import 'package:hive/hive.dart';
import '../models/action_card_model.dart';

class ActionCardLocalDataSource {
  static const String boxName = 'actionCardBox';

  Future<void> saveActionCard(ActionCardModel card) async {
    final box = await Hive.openBox(boxName);
    await box.add(card.toJson());
  }

  Future<List<ActionCardModel>> getAllActionCards() async {
    final box = await Hive.openBox(boxName);
    return box.values
        .map((e) => ActionCardModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}