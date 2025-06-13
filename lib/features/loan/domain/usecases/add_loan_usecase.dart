import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class AddLoanUseCase {
  final LoanRepository repository;

  AddLoanUseCase(this.repository);

  Future<LoanEntity> call(LoanEntity loan) {
    return repository.addLoan(loan);
  }
}
