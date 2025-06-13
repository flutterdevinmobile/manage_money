import '../../domain/entities/goal_entity.dart';

abstract class GoalEvent {}

class GoalLoadRequested extends GoalEvent {
  final String userId;

  GoalLoadRequested({required this.userId});
}

class GoalAddRequested extends GoalEvent {
  final GoalEntity goal;

  GoalAddRequested({required this.goal});
}

class GoalAddToRequested extends GoalEvent {
  final String goalId;
  final double amount;

  GoalAddToRequested({required this.goalId, required this.amount});
}

class GoalDeleteRequested extends GoalEvent {
  final String goalId;

  GoalDeleteRequested({required this.goalId});
}
