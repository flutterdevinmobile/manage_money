import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class AddGoalUseCase {
  final GoalRepository repository;

  AddGoalUseCase(this.repository);

  Future<GoalEntity> call(GoalEntity goal) {
    return repository.addGoal(goal);
  }
}
