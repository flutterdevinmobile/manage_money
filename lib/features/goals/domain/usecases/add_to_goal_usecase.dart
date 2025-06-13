import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class AddToGoalUseCase {
  final GoalRepository repository;

  AddToGoalUseCase(this.repository);

  Future<GoalEntity> call(String goalId, double amount) {
    return repository.addToGoal(goalId, amount);
  }
}
