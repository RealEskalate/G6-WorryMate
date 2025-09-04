import 'package:hive/hive.dart';
import '../models/activity_day_model.dart';

abstract class ActivityLocalDataSource {
  Future<void> init();
  Future<ActivityDayModel?> getDay(DateTime day);
  Future<void> putDay(ActivityDayModel model);
  Future<List<ActivityDayModel>> getRange(DateTime from, DateTime to);
  Future<List<ActivityDayModel>> getAll();
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  static const boxName = 'activity_days_box';
  Box<ActivityDayModel>? _box;

  @override
  Future<void> init() async {
    _box ??= await Hive.openBox<ActivityDayModel>(boxName);
  }

  DateTime _truncate(DateTime d) => DateTime(d.year, d.month, d.day);

  String _key(DateTime d) {
    final t = _truncate(d);
    return '${t.year}-${t.month}-${t.day}';
  }

  @override
  Future<ActivityDayModel?> getDay(DateTime day) async {
    await init();
    return _box!.get(_key(day));
  }

  @override
  Future<void> putDay(ActivityDayModel model) async {
    await init();
    await _box!.put(_key(model.date), model);
  }

  @override
  Future<List<ActivityDayModel>> getRange(DateTime from, DateTime to) async {
    await init();
    final f = _truncate(from);
    final t = _truncate(to);
    return _box!.values
        .where((m) {
          final d = _truncate(m.date);
          return !d.isBefore(f) && !d.isAfter(t);
        })
        .toList();
  }

  @override
  Future<List<ActivityDayModel>> getAll() async {
    await init();
    return _box!.values.toList();
  }
}