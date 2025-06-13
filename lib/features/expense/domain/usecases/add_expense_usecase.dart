import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<ExpenseEntity> call(ExpenseEntity expense) {
    return repository.addExpense(expense);
  }
}
