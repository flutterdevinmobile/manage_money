import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_firestore_service.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalFirestoreService _firestoreService;

  GoalRepositoryImpl(this._firestoreService);

  @override
  Future<List<GoalEntity>> getGoals(String userId) {
    return _firestoreService.getGoals(userId);
  }

  @override
  Future<GoalEntity> addGoal(GoalEntity goal) {
    final goalModel = GoalModel.fromEntity(goal);
    return _firestoreService.addGoal(goalModel);
  }

  @override
  Future<GoalEntity> updateGoal(GoalEntity goal) {
    final goalModel = GoalModel.fromEntity(goal);
    return _firestoreService.updateGoal(goalModel);
  }

  @override
  Future<void> deleteGoal(String goalId) {
    return _firestoreService.deleteGoal(goalId);
  }

  @override
  Future<GoalEntity> addToGoal(String goalId, double amount) {
    return _firestoreService.addToGoal(goalId, amount);
  }

  @override
  Stream<List<GoalEntity>> getGoalsStream(String userId) {
    return _firestoreService.getGoalsStream(userId);
  }
}
