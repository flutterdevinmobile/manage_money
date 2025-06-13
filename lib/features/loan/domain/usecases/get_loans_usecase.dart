import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class GetLoansUseCase {
  final LoanRepository repository;

  GetLoansUseCase(this.repository);

  Future<List<LoanEntity>> call(String userId) {
    return repository.getLoans(userId);
  }
}
