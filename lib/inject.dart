import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Auth Feature
import 'features/auth/data/datasources/firebase_auth_service.dart';
import 'features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Expense Feature
import 'features/expense/data/datasources/expense_firestore_service.dart';
import 'features/expense/data/repositories_impl/expense_repository_impl.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/add_expense_usecase.dart';
import 'features/expense/domain/usecases/delete_expense_usecase.dart';
import 'features/expense/domain/usecases/get_expenses_usecase.dart';
import 'features/expense/domain/usecases/update_expense_usecase.dart';
import 'features/expense/presentation/bloc/expense_bloc.dart';

// Loan Feature
import 'features/loan/data/datasources/loan_firestore_service.dart';
import 'features/loan/data/repositories_impl/loan_repository_impl.dart';
import 'features/loan/domain/repositories/loan_repository.dart';
import 'features/loan/domain/usecases/add_loan_usecase.dart';
import 'features/loan/domain/usecases/get_loans_usecase.dart';
import 'features/loan/domain/usecases/mark_loan_paid_usecase.dart';
import 'features/loan/presentation/bloc/loan_bloc.dart';

// Budget Feature
import 'features/budget/data/datasources/budget_firestore_service.dart';
import 'features/budget/data/repositories_impl/budget_repository_impl.dart';
import 'features/budget/domain/repositories/budget_repository.dart';
import 'features/budget/domain/usecases/add_budget_usecase.dart';
import 'features/budget/domain/usecases/get_budgets_usecase.dart';
import 'features/budget/presentation/bloc/budget_bloc.dart';

// Goals Feature
import 'features/goals/data/datasources/goal_firestore_service.dart';
import 'features/goals/data/repositories_impl/goal_repository_impl.dart';
import 'features/goals/domain/repositories/goal_repository.dart';
import 'features/goals/domain/usecases/add_goal_usecase.dart';
import 'features/goals/domain/usecases/add_to_goal_usecase.dart';
import 'features/goals/domain/usecases/get_goals_usecase.dart';
import 'features/goals/presentation/bloc/goal_bloc.dart';

// Statistics Feature
import 'features/dashboard/data/repositories_impl/statistics_repository_impl.dart';
import 'features/dashboard/domain/repositories/statistics_repository.dart';
import 'features/dashboard/domain/usecases/get_statistics_usecase.dart';

// Data Management Feature
import 'features/data_management/data/datasources/data_management_service.dart';
import 'features/data_management/data/repositories_impl/data_management_repository_impl.dart';
import 'features/data_management/domain/repositories/data_management_repository.dart';
import 'features/data_management/domain/usecases/create_backup_usecase.dart';
import 'features/data_management/domain/usecases/export_data_usecase.dart';
import 'features/data_management/presentation/bloc/data_management_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());

  _setupAuthFeature();
  _setupExpenseFeature();
  _setupLoanFeature();
  _setupBudgetFeature();
  _setupGoalsFeature();
  _setupStatisticsFeature();
  _setupDataManagementFeature();
}

// ========== AUTH ==========
void _setupAuthFeature() {
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => SignInWithGoogleUseCase(getIt()));

  getIt.registerFactory(() => AuthBloc(
        signInUseCase: getIt(),
        signUpUseCase: getIt(),
        signOutUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
        signInWithGoogleUseCase: getIt(),
      ));
}

// ========== EXPENSE ==========
void _setupExpenseFeature() {
  getIt.registerLazySingleton<ExpenseFirestoreService>(() => ExpenseFirestoreService(getIt()));
  getIt.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => GetExpensesUseCase(getIt()));
  getIt.registerLazySingleton(() => AddExpenseUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateExpenseUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteExpenseUseCase(getIt()));

  getIt.registerFactory(() => ExpenseBloc(
        getExpensesUseCase: getIt(),
        addExpenseUseCase: getIt(),
        updateExpenseUseCase: getIt(),
        deleteExpenseUseCase: getIt(),
      ));
}

// ========== LOAN ==========
void _setupLoanFeature() {
  getIt.registerLazySingleton<LoanFirestoreService>(() => LoanFirestoreService(getIt()));
  getIt.registerLazySingleton<LoanRepository>(() => LoanRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => GetLoansUseCase(getIt()));
  getIt.registerLazySingleton(() => AddLoanUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkLoanPaidUseCase(getIt()));

  getIt.registerFactory(() => LoanBloc(
        getLoansUseCase: getIt(),
        addLoanUseCase: getIt(),
        markLoanPaidUseCase: getIt(),
      ));
}

// ========== BUDGET ==========
void _setupBudgetFeature() {
  getIt.registerLazySingleton<BudgetFirestoreService>(() => BudgetFirestoreService(getIt()));
  getIt.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => GetBudgetsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddBudgetUseCase(getIt()));

  getIt.registerFactory(() => BudgetBloc(
        getBudgetsUseCase: getIt(),
        addBudgetUseCase: getIt(),
      ));
}

// ========== GOALS ==========
void _setupGoalsFeature() {
  getIt.registerLazySingleton<GoalFirestoreService>(() => GoalFirestoreService(getIt()));
  getIt.registerLazySingleton<GoalRepository>(() => GoalRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => GetGoalsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddGoalUseCase(getIt()));
  getIt.registerLazySingleton(() => AddToGoalUseCase(getIt()));

  getIt.registerFactory(() => GoalBloc(
        getGoalsUseCase: getIt(),
        addGoalUseCase: getIt(),
        addToGoalUseCase: getIt(),
      ));
}

// ========== STATISTICS ==========
void _setupStatisticsFeature() {
  getIt.registerLazySingleton<StatisticsRepository>(() => StatisticsRepositoryImpl(
        expenseRepository: getIt(),
        loanRepository: getIt(),
      ));
  getIt.registerLazySingleton(() => GetStatisticsUseCase(getIt()));
}

// ========== DATA MANAGEMENT ==========
void _setupDataManagementFeature() {
  getIt.registerLazySingleton<DataManagementService>(() => DataManagementService(getIt()));
  getIt.registerLazySingleton<DataManagementRepository>(() => DataManagementRepositoryImpl(getIt()));

  getIt.registerLazySingleton(() => CreateBackupUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportDataUseCase(getIt()));

  getIt.registerFactory(() => DataManagementBloc(
        createBackupUseCase: getIt(),
        exportDataUseCase: getIt(),
      ));
}
