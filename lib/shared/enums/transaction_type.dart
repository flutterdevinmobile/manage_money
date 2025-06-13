enum TransactionType {
  income,
  expense,
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.income:
        return 'Daromad';
      case TransactionType.expense:
        return 'Xarajat';
    }
  }
}
