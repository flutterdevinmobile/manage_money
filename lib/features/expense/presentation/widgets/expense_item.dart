import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_qarz_app/shared/enums/expense_category.dart';

import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: expense.category.color,
          child: Icon(
            expense.category.icon,
            color: Colors.white,
          ),
        ),
        title: Text(expense.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.category.name),
            Text(
              DateFormat('dd/MM/yyyy').format(expense.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${expense.type == TransactionType.income ? '+' : '-'}${NumberFormat('#,###').format(expense.amount)} so\'m',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: expense.type == TransactionType.income
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: const Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Tahrirlash'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('O\'chirish', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onTap();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
