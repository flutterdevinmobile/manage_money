import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../inject.dart';
import '../../../../shared/enums/budget_period.dart';
import '../../../../shared/enums/expense_category.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/budget_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  ExpenseCategory? _selectedCategory;
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BudgetBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budget qo\'shish'),
          actions: [
            BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state is BudgetLoading ? null : _saveBudget,
                  child: const Text('Saqlash'),
                );
              },
            ),
          ],
        ),
        body: BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is BudgetOperationSuccess) {
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Budget Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Budget nomi',
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Budget nomini kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Summa',
                    prefixIcon: Icon(Icons.attach_money),
                    suffixText: 'so\'m',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Summani kiriting';
                    }
                    if (double.tryParse(value) == null) {
                      return 'To\'g\'ri summa kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Period
                DropdownButtonFormField<BudgetPeriod>(
                  value: _selectedPeriod,
                  decoration: const InputDecoration(
                    labelText: 'Davr',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  items: BudgetPeriod.values.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Category (Optional)
                DropdownButtonFormField<ExpenseCategory?>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategoriya (ixtiyoriy)',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    const DropdownMenuItem<ExpenseCategory?>(
                      value: null,
                      child: Text('Barcha kategoriyalar'),
                    ),
                    ...ExpenseCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Start Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Boshlanish sanasi'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                  onTap: _selectStartDate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  DateTime _calculateEndDate() {
    switch (_selectedPeriod) {
      case BudgetPeriod.weekly:
        return _startDate.add(const Duration(days: 7));
      case BudgetPeriod.monthly:
        return DateTime(_startDate.year, _startDate.month + 1, _startDate.day);
      case BudgetPeriod.yearly:
        return DateTime(_startDate.year + 1, _startDate.month, _startDate.day);
    }
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final budget = BudgetEntity(
          id: '',
          userId: authState.user.id,
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          spent: 0,
          category: _selectedCategory,
          period: _selectedPeriod,
          startDate: _startDate,
          endDate: _calculateEndDate(),
          isActive: true,
          createdAt: DateTime.now(),
        );

        context.read<BudgetBloc>().add(BudgetAddRequested(budget: budget));
      }
    }
  }
}
