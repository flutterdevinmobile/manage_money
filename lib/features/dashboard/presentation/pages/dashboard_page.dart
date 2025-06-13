import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_qarz_app/shared/enums/expense_category.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../inject.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../expense/presentation/bloc/expense_bloc.dart';
import '../../../expense/presentation/bloc/expense_event.dart';
import '../../../expense/presentation/bloc/expense_state.dart';
import '../../../expense/presentation/pages/add_expense_page.dart';
import '../../../loan/presentation/bloc/loan_bloc.dart';
import '../../../loan/presentation/bloc/loan_event.dart';
import '../../../loan/presentation/bloc/loan_state.dart';
import '../../../loan/presentation/pages/add_loan_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ExpenseBloc>()),
        BlocProvider(create: (context) => getIt<LoanBloc>()),
      ],
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ExpenseBloc>().add(
        ExpenseLoadRequested(userId: authState.user.id),
      );
      context.read<LoanBloc>().add(
        LoanLoadRequested(userId: authState.user.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome Card
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // CircleAvatar(
                          //   backgroundImage: state.user.photoUrl != null
                          //       ? NetworkImage(state.user.photoUrl!)
                          //       : null,
                          //   child: state.user.photoUrl == null
                          //       ? const Icon(Icons.person)
                          //       : null,
                          // ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Salom, ${state.user.displayName ?? 'Foydalanuvchi'}!',
                                //   style: const TextStyle(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                Text(
                                  'Bugun ${DateFormat('dd MMMM, yyyy', 'uz').format(DateTime.now())}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),

            // Balance Overview
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                double totalIncome = 0;
                double totalExpense = 0;

                if (state is ExpenseLoaded) {
                  for (final expense in state.expenses) {
                    if (expense.type.name == 'income') {
                      totalIncome += expense.amount;
                    } else {
                      totalExpense += expense.amount;
                    }
                  }
                }

                final balance = totalIncome - totalExpense;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          AppStrings.totalBalance,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${NumberFormat('#,###').format(balance)} so\'m',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: balance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    AppStrings.income,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    '${NumberFormat('#,###').format(totalIncome)} so\'m',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    AppStrings.expense,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    '${NumberFormat('#,###').format(totalExpense)} so\'m',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => _addTransaction(context),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.add, size: 32, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Tranzaksiya\nqo\'shish'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => _addLoan(context),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.handshake, size: 32, color: Colors.orange),
                            SizedBox(height: 8),
                            Text('Qarz\nqo\'shish'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent Transactions
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoaded && state.expenses.isNotEmpty) {
                  final recentExpenses = state.expenses.take(5).toList();
                  
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'So\'nggi tranzaksiyalar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...recentExpenses.map((expense) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: expense.category.color,
                                  child: Icon(
                                    expense.category.icon,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense.description,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(expense.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${expense.type.name == 'income' ? '+' : '-'}${NumberFormat('#,###').format(expense.amount)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: expense.type.name == 'income' 
                                        ? Colors.green 
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),

            // Active Loans
            BlocBuilder<LoanBloc, LoanState>(
              builder: (context, state) {
                if (state is LoanLoaded && state.loans.isNotEmpty) {
                  final activeLoans = state.loans
                      .where((loan) => loan.status.name == 'active')
                      .take(3)
                      .toList();

                  if (activeLoans.isNotEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Faol qarzlar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...activeLoans.map((loan) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: loan.type.name == 'lent' 
                                        ? Colors.green 
                                        : Colors.orange,
                                    child: Icon(
                                      loan.type.name == 'lent' 
                                          ? Icons.call_made 
                                          : Icons.call_received,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          loan.contactName,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Muddat: ${DateFormat('dd/MM/yyyy').format(loan.dueDate)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: loan.dueDate.isBefore(DateTime.now())
                                                ? Colors.red
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat('#,###').format(loan.amount)} so\'m',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: loan.type.name == 'lent' 
                                          ? Colors.green 
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    ).then((_) => _loadData());
  }

  void _addLoan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddLoanPage(),
      ),
    ).then((_) => _loadData());
  }
}
