// ...existing code...
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/activity_day.dart';
import '../../domain/usecases/compute_streak_use_case.dart';
import '../../domain/usecases/get_last_n_days_use_case.dart';
import '../../domain/usecases/log_activity_use_case.dart';
import '../../domain/usecases/log_mood_use_case.dart';
import 'activity_state.dart';
// ...existing code...

class ActivityCubit extends Cubit<ActivityState> {
  final LogActivityUseCase _logActivity;
  final LogMoodUseCase _logMood;
  final GetLastNDaysUseCase _getLastNDays;
  final ComputeStreakUseCase _computeStreak;

  static const int windowDays = 7;
  static const int dailyMax = 5;

  ActivityCubit(
    this._logActivity,
    this._logMood,
    this._getLastNDays,
    this._computeStreak,
  ) : super(const ActivityLoading());

  Future<void> load() async {
    emit(const ActivityLoading());
    final days = await _getLastNDays(windowDays);
    final streak = await _computeStreak();
    emit(ActivityReady(daysByKey: _byKey(days), streak: streak));
  }

  Future<void> logActivity(String id) async {
    if (state is! ActivityReady) return;
    await _logActivity(id);
    await _refresh();
  }

  Future<void> logMood(String mood) async {
    if (state is! ActivityReady) return;
    await _logMood(mood);
    await _refresh();
  }

  Future<void> _refresh() async {
    final days = await _getLastNDays(windowDays);
    final streak = await _computeStreak();
    emit(ActivityReady(daysByKey: _byKey(days), streak: streak));
  }

  static Map<String, ActivityDay> _byKey(List<ActivityDay> list) => {
        for (final d in list)
          '${d.date.year}-${d.date.month}-${d.date.day}': d,
      };
}