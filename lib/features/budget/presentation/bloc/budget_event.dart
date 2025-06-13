import '../../domain/entities/budget_entity.dart';

abstract class BudgetEvent {}

class BudgetLoadRequested extends BudgetEvent {
  final String userId;

  BudgetLoadRequested({required this.userId});
}

class BudgetAddRequested extends BudgetEvent {
  final BudgetEntity budget;

  BudgetAddRequested({required this.budget});
}

class BudgetUpdateRequested extends BudgetEvent {
  final BudgetEntity budget;

  BudgetUpdateRequested({required this.budget});
}

class BudgetDeleteRequested extends BudgetEvent {
  final String budgetId;

  BudgetDeleteRequested({required this.budgetId});
}
