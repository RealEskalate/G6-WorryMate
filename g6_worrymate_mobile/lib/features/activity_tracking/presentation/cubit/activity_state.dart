import 'package:equatable/equatable.dart';
import '../../../activity_tracking/domain/entities/activity_day.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object?> get props => [];
}

class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

class ActivityReady extends ActivityState {
  final Map<String, ActivityDay> daysByKey;
  final int streak;
  const ActivityReady({
    required this.daysByKey,
    required this.streak,
  });

  int get todayCount {
    final key = _k(DateTime.now());
    return daysByKey[key]?.activities.length ?? 0;
  }

  int totalLast7() =>
      daysByKey.values.fold(0, (s, d) => s + d.activities.length);

  ActivityDay? get today => daysByKey[_k(DateTime.now())];

  static String _k(DateTime d) => '${d.year}-${d.month}-${d.day}';

  @override
  List<Object?> get props => [daysByKey, streak];
}