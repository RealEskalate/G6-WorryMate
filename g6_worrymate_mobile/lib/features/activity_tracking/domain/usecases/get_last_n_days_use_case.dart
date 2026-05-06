import '../../domain/entities/activity_day.dart';
import '../../domain/repositories/activity_repository.dart';

class GetLastNDaysUseCase {
  final ActivityRepository _repo;
  GetLastNDaysUseCase(this._repo);

  Future<List<ActivityDay>> call(int n) {
    return _repo.getLastNDays(n);
  }
}