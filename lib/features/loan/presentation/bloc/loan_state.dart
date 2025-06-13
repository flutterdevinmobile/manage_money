import '../../domain/entities/loan_entity.dart';

abstract class LoanState {}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanLoaded extends LoanState {
  final List<LoanEntity> loans;

  LoanLoaded({required this.loans});
}

class LoanError extends LoanState {
  final String message;

  LoanError({required this.message});
}

class LoanOperationSuccess extends LoanState {
  final String message;

  LoanOperationSuccess({required this.message});
}
