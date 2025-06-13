import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> getGoals(String userId);
  Future<GoalEntity> addGoal(GoalEntity goal);
  Future<GoalEntity> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String goalId);
  Future<GoalEntity> addToGoal(String goalId, double amount);
  Stream<List<GoalEntity>> getGoalsStream(String userId);
}
