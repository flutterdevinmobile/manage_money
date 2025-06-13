enum LoanType {
  lent,
  borrowed,
}

extension LoanTypeExtension on LoanType {
  String get name {
    switch (this) {
      case LoanType.lent:
        return 'Qarz berdim';
      case LoanType.borrowed:
        return 'Qarz oldim';
    }
  }
}
