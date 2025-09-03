import '../../domain/entities/activity_day.dart';
import '../../domain/repositories/activity_repository.dart';

class LogActivityUseCase {
  final ActivityRepository _repo;
  LogActivityUseCase(this._repo);

  Future<ActivityDay> call(String id, {DateTime? when}) {
    return _repo.logActivity(id, when: when);
  }
}