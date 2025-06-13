import 'package:flutter/material.dart';

import '../../../expense/presentation/pages/expense_list_page.dart';
import '../../../loan/presentation/pages/loan_list_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'dashboard_page.dart';
import 'statistics_page.dart';
import '../../../budget/presentation/pages/budget_list_page.dart';
import '../../../goals/presentation/pages/goals_list_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const ExpenseListPage(),
    const LoanListPage(),
    const BudgetListPage(),
    const GoalsListPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Bosh sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Xarajatlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Qarzlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Maqsadlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistika',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Sozlamalar',
          ),
        ],
      ),
    );
  }
}
