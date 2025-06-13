class StatisticsEntity {
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final Map<String, double> categoryExpenses;
  final List<DailyExpense> dailyExpenses;

  const StatisticsEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.categoryExpenses,
    required this.dailyExpenses,
  });
}

class DailyExpense {
  final DateTime date;
  final double amount;

  const DailyExpense({
    required this.date,
    required this.amount,
  });
}
