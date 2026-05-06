import '../entities/activity_day.dart';

abstract class ActivityRepository {
  Future<ActivityDay> logActivity(String id, {DateTime? when});
  Future<ActivityDay> logMood(String mood, {DateTime? when});
  Future<ActivityDay?> getDay(DateTime day);
  Future<List<ActivityDay>> getLastNDays(int n);
  Future<int> computeStreak();
}