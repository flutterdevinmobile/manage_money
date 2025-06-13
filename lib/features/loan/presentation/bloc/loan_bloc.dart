import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_loan_usecase.dart';
import '../../domain/usecases/get_loans_usecase.dart';
import '../../domain/usecases/mark_loan_paid_usecase.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final GetLoansUseCase getLoansUseCase;
  final AddLoanUseCase addLoanUseCase;
  final MarkLoanPaidUseCase markLoanPaidUseCase;

  LoanBloc({
    required this.getLoansUseCase,
    required this.addLoanUseCase,
    required this.markLoanPaidUseCase,
  }) : super(LoanInitial()) {
    on<LoanLoadRequested>(_onLoadRequested);
    on<LoanAddRequested>(_onAddRequested);
    on<LoanMarkPaidRequested>(_onMarkPaidRequested);
  }

  Future<void> _onLoadRequested(
    LoanLoadRequested event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    try {
      final loans = await getLoansUseCase(event.userId);
      emit(LoanLoaded(loans: loans));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    LoanAddRequested event,
    Emitter<LoanState> emit,
  ) async {
    try {
      await addLoanUseCase(event.loan);
      emit(LoanOperationSuccess(message: 'Qarz qo\'shildi'));
      add(LoanLoadRequested(userId: event.loan.userId));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  Future<void> _onMarkPaidRequested(
    LoanMarkPaidRequested event,
    Emitter<LoanState> emit,
  ) async {
    try {
      await markLoanPaidUseCase(event.loanId);
      emit(LoanOperationSuccess(message: 'Qarz to\'langan deb belgilandi'));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }
}
