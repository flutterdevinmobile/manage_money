import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_qarz_app/core/router/app_router.dart';
import 'package:manage_qarz_app/core/theme/app_theme.dart';
import 'package:manage_qarz_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:manage_qarz_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:manage_qarz_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:manage_qarz_app/features/data_management/presentation/bloc/data_management_bloc.dart';
import 'package:manage_qarz_app/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:manage_qarz_app/features/goals/presentation/bloc/goal_bloc.dart';
import 'package:manage_qarz_app/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:manage_qarz_app/inject.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => getIt<ExpenseBloc>()),
        BlocProvider(create: (_) => getIt<LoanBloc>()),
        BlocProvider(create: (_) => getIt<BudgetBloc>()),
        BlocProvider(create: (_) => getIt<GoalBloc>()),
        BlocProvider(create: (_) => getIt<DataManagementBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Manage My Money',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig:appRouter,
      ),
    );
  }
}
