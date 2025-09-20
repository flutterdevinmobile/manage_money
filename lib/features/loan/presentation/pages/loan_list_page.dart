import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inject.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/loan_bloc.dart';
import '../bloc/loan_event.dart';
import '../bloc/loan_state.dart';
import '../widgets/loan_item.dart';
import 'add_loan_page.dart';

class LoanListPage extends StatelessWidget {
  const LoanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoanBloc>(),
      child: const LoanListView(),
    );
  }
}

class LoanListView extends StatefulWidget {
  const LoanListView({super.key});

  @override
  State<LoanListView> createState() => _LoanListViewState();
}

class _LoanListViewState extends State<LoanListView> {
  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  void _loadLoans() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<LoanBloc>().add(
            LoanLoadRequested(userId: authState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qarzlar'),
      ),
      body: BlocListener<LoanBloc, LoanState>(
        listener: (context, state) {
          if (state is LoanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoanOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            _loadLoans();
          }
        },
        child: BlocBuilder<LoanBloc, LoanState>(
          builder: (context, state) {
            if (state is LoanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoanLoaded) {
              if (state.loans.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.handshake, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Hech qanday qarz yo',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _loadLoans(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.loans.length,
                  itemBuilder: (context, index) {
                    final loan = state.loans[index];
                    return LoanItem(
                      loan: loan,
                      onMarkPaid: () => _markAsPaid(loan.id),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addLoan(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addLoan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddLoanPage(),
      ),
    ).then((_) => _loadLoans());
  }

  void _markAsPaid(String loanId) {
    context.read<LoanBloc>().add(LoanMarkPaidRequested(loanId: loanId));
  }
}
