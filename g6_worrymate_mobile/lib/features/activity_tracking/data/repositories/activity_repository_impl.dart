import '../../domain/entities/activity_day.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_local_data_soruce.dart';
import '../models/activity_day_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource local;
  static const _validIds = <String>{
    'journal',
    'breathing',
    'trackWins',
    'chatAI',
    'moodCheckIn',
  };

  ActivityRepositoryImpl(this.local);

  DateTime _truncate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<ActivityDayModel> _ensure(DateTime day) async {
    final existing = await local.getDay(day);
    if (existing != null) return existing;
    final model = ActivityDayModel(date: _truncate(day), activities: []);
    await local.putDay(model);
    return model;
  }

  @override
  Future<ActivityDay> logActivity(String id, {DateTime? when}) async {
    final ts = when ?? DateTime.now();
    final model = await _ensure(ts);
    if (_validIds.contains(id) && !model.activities.contains(id)) {
      model.activities.add(id);
      await local.putDay(model);
    }
    return model.toEntity();
  }

  @override
  Future<ActivityDay> logMood(String mood, {DateTime? when}) async {
    final ts = when ?? DateTime.now();
    final model = await _ensure(ts);
    model.mood = mood;
    if (!model.activities.contains('moodCheckIn')) {
      model.activities.add('moodCheckIn');
    }
    await local.putDay(model);
    return model.toEntity();
  }

  @override
  Future<ActivityDay?> getDay(DateTime day) async {
    final m = await local.getDay(day);
    return m?.toEntity();
  }

  @override
  Future<List<ActivityDay>> getLastNDays(int n) async {
    final now = DateTime.now();
    final from = now.subtract(Duration(days: n - 1));
    final list = await local.getRange(from, now);
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> computeStreak() async {
    final all = await local.getAll();
    if (all.isEmpty) return 0;
    final dates = all.map((m) => _truncate(m.date)).toSet();
    int streak = 0;
    var cursor = _truncate(DateTime.now());
    while (dates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}