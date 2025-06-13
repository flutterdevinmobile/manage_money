import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../inject.dart';
import '../../../../shared/enums/expense_category.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class AddExpensePage extends StatefulWidget {
  final ExpenseEntity? expense;

  const AddExpensePage({super.key, this.expense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  ExpenseCategory _selectedCategory = ExpenseCategory.other;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedType = widget.expense!.type;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExpenseBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.expense == null
              ? AppStrings.addTransaction
              : AppStrings.editTransaction),
          actions: [
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    _saveExpense();
                  },
                  child: const Text(
                    AppStrings.save,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ExpenseOperationSuccess) {
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Transaction Type
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tranzaksiya turi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<TransactionType>(
                                title: Text(TransactionType.income.name),
                                value: TransactionType.income,
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<TransactionType>(
                                title: Text(TransactionType.expense.name),
                                value: TransactionType.expense,
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: AppStrings.amount,
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

                // Category
                DropdownButtonFormField<ExpenseCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: AppStrings.category,
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: ExpenseCategory.values.map((category) {
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
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.description,
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Izoh kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(AppStrings.date),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                  onTap: _selectDate,
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

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveExpense() {
    print(widget.expense);
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      print('Saving expense: ${_amountController.text}');
      if (authState is AuthAuthenticated) {
        print('Saving expense: ${_amountController.text}');
        final expense = ExpenseEntity(
          id: widget.expense?.id ?? '',
          userId: authState.user.id,
          amount: double.parse(_amountController.text),
          description: _descriptionController.text,
          category: _selectedCategory,
          type: _selectedType,
          date: _selectedDate,
          createdAt: widget.expense?.createdAt ?? DateTime.now(),
        );
        print(expense);
        if (widget.expense == null) {
          print('Adding new expense: $expense');
          context
              .read<ExpenseBloc>()
              .add(ExpenseAddRequested(expense: expense));
          context.go('/main');
        } else {
          print('Updating expense: $expense');
          context
              .read<ExpenseBloc>()
              .add(ExpenseUpdateRequested(expense: expense));
        }
      }
    }
  }
}
