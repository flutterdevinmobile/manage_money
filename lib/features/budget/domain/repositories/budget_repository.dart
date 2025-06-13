import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getBudgets(String userId);
  Future<BudgetEntity> addBudget(BudgetEntity budget);
  Future<BudgetEntity> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(String budgetId);
  Future<BudgetEntity> updateBudgetSpent(String budgetId, double spent);
  Stream<List<BudgetEntity>> getBudgetsStream(String userId);
}
