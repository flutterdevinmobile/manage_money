import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_firestore_service.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetFirestoreService _firestoreService;

  BudgetRepositoryImpl(this._firestoreService);

  @override
  Future<List<BudgetEntity>> getBudgets(String userId) {
    return _firestoreService.getBudgets(userId);
  }

  @override
  Future<BudgetEntity> addBudget(BudgetEntity budget) {
    final budgetModel = BudgetModel.fromEntity(budget);
    return _firestoreService.addBudget(budgetModel);
  }

  @override
  Future<BudgetEntity> updateBudget(BudgetEntity budget) {
    final budgetModel = BudgetModel.fromEntity(budget);
    return _firestoreService.updateBudget(budgetModel);
  }

  @override
  Future<void> deleteBudget(String budgetId) {
    return _firestoreService.deleteBudget(budgetId);
  }

  @override
  Future<BudgetEntity> updateBudgetSpent(String budgetId, double spent) async {
    // This would require a separate method in the service
    throw UnimplementedError();
  }

  @override
  Stream<List<BudgetEntity>> getBudgetsStream(String userId) {
    return _firestoreService.getBudgetsStream(userId);
  }
}
