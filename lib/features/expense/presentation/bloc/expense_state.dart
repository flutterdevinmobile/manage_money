import '../../domain/entities/expense_entity.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseEntity> expenses;

  ExpenseLoaded({required this.expenses});
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError({required this.message});
}

class ExpenseOperationSuccess extends ExpenseState {
  final String message;

  ExpenseOperationSuccess({required this.message});
}
