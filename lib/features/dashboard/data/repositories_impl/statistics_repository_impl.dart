import '../../domain/entities/statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../../expense/domain/repositories/expense_repository.dart';
import '../../../loan/domain/repositories/loan_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final ExpenseRepository expenseRepository;
  final LoanRepository loanRepository;

  StatisticsRepositoryImpl({
    required this.expenseRepository,
    required this.loanRepository,
  });

  @override
  Future<StatisticsEntity> getStatistics(String userId) async {
    final expenses = await expenseRepository.getExpenses(userId);

    double totalIncome = 0;
    double totalExpense = 0;
    double monthlyIncome = 0;
    double monthlyExpense = 0;
    Map<String, double> categoryExpenses = {};
    List<DailyExpense> dailyExpenses = [];

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    for (final expense in expenses) {
      if (expense.type.name == 'income') {
        totalIncome += expense.amount;
        if (expense.date.isAfter(monthStart)) {
          monthlyIncome += expense.amount;
        }
      } else {
        totalExpense += expense.amount;
        if (expense.date.isAfter(monthStart)) {
          monthlyExpense += expense.amount;
        }
        
        // Category expenses
        final categoryName = expense.category.name;
        categoryExpenses[categoryName] = 
            (categoryExpenses[categoryName] ?? 0) + expense.amount;
      }
    }

    // Calculate daily expenses for the last 30 days
    final last30Days = now.subtract(const Duration(days: 30));
    final dailyExpenseMap = <String, double>{};

    for (final expense in expenses) {
      if (expense.date.isAfter(last30Days) && expense.type.name == 'expense') {
        final dateKey = '${expense.date.year}-${expense.date.month}-${expense.date.day}';
        dailyExpenseMap[dateKey] = (dailyExpenseMap[dateKey] ?? 0) + expense.amount;
      }
    }

    dailyExpenses = dailyExpenseMap.entries
        .map((entry) => DailyExpense(
              date: DateTime.parse(entry.key),
              amount: entry.value,
            ))
        .toList();

    return StatisticsEntity(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalBalance: totalIncome - totalExpense,
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
      categoryExpenses: categoryExpenses,
      dailyExpenses: dailyExpenses,
    );
  }

  @override
  Future<StatisticsEntity> getStatisticsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    // Implementation for date range statistics
    return getStatistics(userId); // Simplified for now
  }
}
