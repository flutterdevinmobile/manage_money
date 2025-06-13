import '../../domain/entities/expense_entity.dart';

abstract class ExpenseEvent {}

class ExpenseLoadRequested extends ExpenseEvent {
  final String userId;

  ExpenseLoadRequested({required this.userId});
}

class ExpenseAddRequested extends ExpenseEvent {
  final ExpenseEntity expense;

  ExpenseAddRequested({required this.expense});
}

class ExpenseUpdateRequested extends ExpenseEvent {
  final ExpenseEntity expense;

  ExpenseUpdateRequested({required this.expense});
}

class ExpenseDeleteRequested extends ExpenseEvent {
  final String expenseId;

  ExpenseDeleteRequested({required this.expenseId});
}
