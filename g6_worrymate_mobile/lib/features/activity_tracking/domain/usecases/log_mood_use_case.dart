import '../../domain/entities/activity_day.dart';
import '../../domain/repositories/activity_repository.dart';

class LogMoodUseCase {
  final ActivityRepository _repo;
  LogMoodUseCase(this._repo);

  Future<ActivityDay> call(String mood, {DateTime? when}) {
    return _repo.logMood(mood, when: when);
  }
}