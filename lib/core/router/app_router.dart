import 'package:go_router/go_router.dart';
import 'package:manage_qarz_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:manage_qarz_app/features/dashboard/presentation/pages/main_page.dart';

// Pages
import '../../../features/auth/presentation/pages/sign_in_page.dart';
import '../../../features/budget/presentation/pages/add_budget_page.dart';
import '../../../features/budget/presentation/pages/budget_list_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/expense/presentation/pages/add_expense_page.dart';
import '../../../features/expense/presentation/pages/expense_list_page.dart';
import '../../../features/goals/presentation/pages/add_goal_page.dart';
import '../../../features/goals/presentation/pages/goals_list_page.dart';
import '../../../features/loan/presentation/pages/add_loan_page.dart';
import '../../../features/loan/presentation/pages/loan_list_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../features/onboarding/presentation/pages/splash_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/expenses',
      builder: (context, state) => const ExpenseListPage(),
    ),
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpensePage(),
    ),
    GoRoute(
      path: '/loans',
      builder: (context, state) => const LoanListPage(),
    ),
    GoRoute(
      path: '/add-loan',
      builder: (context, state) => const AddLoanPage(),
    ),
    GoRoute(
      path: '/budgets',
      builder: (context, state) => const BudgetListPage(),
    ),
    GoRoute(
      path: '/add-budget',
      builder: (context, state) => const AddBudgetPage(),
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => const GoalsListPage(),
    ),
    GoRoute(
      path: '/add-goal',
      builder: (context, state) => const AddGoalPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
