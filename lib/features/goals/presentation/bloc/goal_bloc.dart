import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_goal_usecase.dart';
import '../../domain/usecases/add_to_goal_usecase.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GetGoalsUseCase getGoalsUseCase;
  final AddGoalUseCase addGoalUseCase;
  final AddToGoalUseCase addToGoalUseCase;

  GoalBloc({
    required this.getGoalsUseCase,
    required this.addGoalUseCase,
    required this.addToGoalUseCase,
  }) : super(GoalInitial()) {
    on<GoalLoadRequested>(_onLoadRequested);
    on<GoalAddRequested>(_onAddRequested);
    on<GoalAddToRequested>(_onAddToRequested);
  }

  Future<void> _onLoadRequested(
    GoalLoadRequested event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    try {
      final goals = await getGoalsUseCase(event.userId);
      emit(GoalLoaded(goals: goals));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    GoalAddRequested event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await addGoalUseCase(event.goal);
      emit(GoalOperationSuccess(message: 'Maqsad qo\'shildi'));
      add(GoalLoadRequested(userId: event.goal.userId));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }

  Future<void> _onAddToRequested(
    GoalAddToRequested event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await addToGoalUseCase(event.goalId, event.amount);
      emit(GoalOperationSuccess(message: 'Maqsadga pul qo\'shildi'));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }
}
