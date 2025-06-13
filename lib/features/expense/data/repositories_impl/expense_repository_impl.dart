import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_firestore_service.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseFirestoreService _firestoreService;

  ExpenseRepositoryImpl(this._firestoreService);

  @override
  Future<List<ExpenseEntity>> getExpenses(String userId) {
    return _firestoreService.getExpenses(userId);
  }

  @override
  Future<ExpenseEntity> addExpense(ExpenseEntity expense) {
    final expenseModel = ExpenseModel.fromEntity(expense);
    return _firestoreService.addExpense(expenseModel);
  }

  @override
  Future<ExpenseEntity> updateExpense(ExpenseEntity expense) {
    final expenseModel = ExpenseModel.fromEntity(expense);
    return _firestoreService.updateExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(String expenseId) {
    return _firestoreService.deleteExpense(expenseId);
  }

  @override
  Stream<List<ExpenseEntity>> getExpensesStream(String userId) {
    return _firestoreService.getExpensesStream(userId);
  }
}
