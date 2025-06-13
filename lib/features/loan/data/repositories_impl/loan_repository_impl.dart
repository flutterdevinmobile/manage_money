import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';
import '../datasources/loan_firestore_service.dart';
import '../models/loan_model.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanFirestoreService _firestoreService;

  LoanRepositoryImpl(this._firestoreService);

  @override
  Future<List<LoanEntity>> getLoans(String userId) {
    return _firestoreService.getLoans(userId);
  }

  @override
  Future<LoanEntity> addLoan(LoanEntity loan) {
    final loanModel = LoanModel.fromEntity(loan);
    return _firestoreService.addLoan(loanModel);
  }

  @override
  Future<LoanEntity> updateLoan(LoanEntity loan) {
    final loanModel = LoanModel.fromEntity(loan);
    return _firestoreService.updateLoan(loanModel);
  }

  @override
  Future<void> deleteLoan(String loanId) {
    return _firestoreService.deleteLoan(loanId);
  }

  @override
  Future<LoanEntity> markAsPaid(String loanId) {
    return _firestoreService.markAsPaid(loanId);
  }

  @override
  Stream<List<LoanEntity>> getLoansStream(String userId) {
    return _firestoreService.getLoansStream(userId);
  }
}
