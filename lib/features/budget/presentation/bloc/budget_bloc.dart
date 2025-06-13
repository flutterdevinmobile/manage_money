import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_budget_usecase.dart';
import '../../domain/usecases/get_budgets_usecase.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetsUseCase getBudgetsUseCase;
  final AddBudgetUseCase addBudgetUseCase;

  BudgetBloc({
    required this.getBudgetsUseCase,
    required this.addBudgetUseCase,
  }) : super(BudgetInitial()) {
    on<BudgetLoadRequested>(_onLoadRequested);
    on<BudgetAddRequested>(_onAddRequested);
  }

  Future<void> _onLoadRequested(
    BudgetLoadRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      final budgets = await getBudgetsUseCase(event.userId);
      emit(BudgetLoaded(budgets: budgets));
    } catch (e) {
      emit(BudgetError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    BudgetAddRequested event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await addBudgetUseCase(event.budget);
      emit(BudgetOperationSuccess(message: 'Budget qo\'shildi'));
      add(BudgetLoadRequested(userId: event.budget.userId));
    } catch (e) {
      emit(BudgetError(message: e.toString()));
    }
  }
}
