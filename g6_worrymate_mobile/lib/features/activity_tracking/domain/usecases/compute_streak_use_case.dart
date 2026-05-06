import '../../domain/repositories/activity_repository.dart';

class ComputeStreakUseCase {
  final ActivityRepository _repo;
  ComputeStreakUseCase(this._repo);

  Future<int> call() {
    return _repo.computeStreak();
  }
}