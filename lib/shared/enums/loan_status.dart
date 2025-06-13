enum LoanStatus {
  active,
  paid,
  overdue,
}

extension LoanStatusExtension on LoanStatus {
  String get name {
    switch (this) {
      case LoanStatus.active:
        return 'Faol';
      case LoanStatus.paid:
        return 'To\'langan';
      case LoanStatus.overdue:
        return 'Muddati o\'tgan';
    }
  }
}
