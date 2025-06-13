enum BudgetPeriod {
  weekly,
  monthly,
  yearly,
}

extension BudgetPeriodExtension on BudgetPeriod {
  String get name {
    switch (this) {
      case BudgetPeriod.weekly:
        return 'Haftalik';
      case BudgetPeriod.monthly:
        return 'Oylik';
      case BudgetPeriod.yearly:
        return 'Yillik';
    }
  }
}
