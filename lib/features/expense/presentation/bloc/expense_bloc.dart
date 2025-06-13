import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpensesUseCase getExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(ExpenseInitial()) {
    on<ExpenseLoadRequested>(_onLoadRequested);
    on<ExpenseAddRequested>(_onAddRequested);
    on<ExpenseUpdateRequested>(_onUpdateRequested);
    on<ExpenseDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    ExpenseLoadRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await getExpensesUseCase(event.userId);
      emit(ExpenseLoaded(expenses: expenses));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
    ExpenseAddRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await addExpenseUseCase(event.expense);
      emit(ExpenseOperationSuccess(message: 'Tranzaksiya qo\'shildi'));
      // Reload expenses
      add(ExpenseLoadRequested(userId: event.expense.userId));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    ExpenseUpdateRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await updateExpenseUseCase(event.expense);
      emit(ExpenseOperationSuccess(message: 'Tranzaksiya yangilandi'));
      // Reload expenses
      add(ExpenseLoadRequested(userId: event.expense.userId));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    ExpenseDeleteRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await deleteExpenseUseCase(event.expenseId);
      emit(ExpenseOperationSuccess(message: 'Tranzaksiya o\'chirildi'));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }
}
