import '../../domain/entities/budget_entity.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetEntity> budgets;

  BudgetLoaded({required this.budgets});
}

class BudgetError extends BudgetState {
  final String message;

  BudgetError({required this.message});
}

class BudgetOperationSuccess extends BudgetState {
  final String message;

  BudgetOperationSuccess({required this.message});
}
