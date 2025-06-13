import '../entities/loan_entity.dart';

abstract class LoanRepository {
  Future<List<LoanEntity>> getLoans(String userId);
  Future<LoanEntity> addLoan(LoanEntity loan);
  Future<LoanEntity> updateLoan(LoanEntity loan);
  Future<void> deleteLoan(String loanId);
  Future<LoanEntity> markAsPaid(String loanId);
  Stream<List<LoanEntity>> getLoansStream(String userId);
}
