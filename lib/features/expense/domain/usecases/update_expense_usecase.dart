import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<ExpenseEntity> call(ExpenseEntity expense) {
    return repository.updateExpense(expense);
  }
}
