import '../../../../shared/enums/budget_period.dart';
import '../../../../shared/enums/expense_category.dart';

class BudgetEntity {
  final String id;
  final String userId;
  final String name;
  final double amount;
  final double spent;
  final ExpenseCategory? category;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;

  const BudgetEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.spent,
    this.category,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
  });

  double get remainingAmount => amount - spent;
  double get progressPercentage => spent / amount * 100;
  bool get isOverBudget => spent > amount;
}
