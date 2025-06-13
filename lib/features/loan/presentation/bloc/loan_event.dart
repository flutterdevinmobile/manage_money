import '../../domain/entities/loan_entity.dart';

abstract class LoanEvent {}

class LoanLoadRequested extends LoanEvent {
  final String userId;

  LoanLoadRequested({required this.userId});
}

class LoanAddRequested extends LoanEvent {
  final LoanEntity loan;

  LoanAddRequested({required this.loan});
}

class LoanMarkPaidRequested extends LoanEvent {
  final String loanId;

  LoanMarkPaidRequested({required this.loanId});
}

class LoanDeleteRequested extends LoanEvent {
  final String loanId;

  LoanDeleteRequested({required this.loanId});
}
