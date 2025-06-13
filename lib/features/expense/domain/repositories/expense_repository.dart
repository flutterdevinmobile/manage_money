import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses(String userId);
  Future<ExpenseEntity> addExpense(ExpenseEntity expense);
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String expenseId);
  Stream<List<ExpenseEntity>> getExpensesStream(String userId);
}
