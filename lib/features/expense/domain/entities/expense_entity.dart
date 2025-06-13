import '../../../../shared/enums/expense_category.dart';
import '../../../../shared/enums/transaction_type.dart';

class ExpenseEntity {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final ExpenseCategory category;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;

  const ExpenseEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.type,
    required this.date,
    required this.createdAt,
  });
}
