import '../../domain/entities/goal_entity.dart';

abstract class GoalState {}

class GoalInitial extends GoalState {}

class GoalLoading extends GoalState {}

class GoalLoaded extends GoalState {
  final List<GoalEntity> goals;

  GoalLoaded({required this.goals});
}

class GoalError extends GoalState {
  final String message;

  GoalError({required this.message});
}

class GoalOperationSuccess extends GoalState {
  final String message;

  GoalOperationSuccess({required this.message});
}
