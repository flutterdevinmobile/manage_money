import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class MarkLoanPaidUseCase {
  final LoanRepository repository;

  MarkLoanPaidUseCase(this.repository);

  Future<LoanEntity> call(String loanId) {
    return repository.markAsPaid(loanId);
  }
}
