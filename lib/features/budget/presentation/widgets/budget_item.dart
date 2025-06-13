import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_qarz_app/shared/enums/expense_category.dart';

import '../../domain/entities/budget_entity.dart';

class BudgetItem extends StatelessWidget {
  final BudgetEntity budget;

  const BudgetItem({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    budget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: budget.isOverBudget ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    budget.period.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (budget.category != null) ...[
              Row(
                children: [
                  Icon(budget.category!.icon, size: 16, color: budget.category!.color),
                  const SizedBox(width: 4),
                  Text(
                    budget.category!.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${NumberFormat('#,###').format(budget.spent)} / ${NumberFormat('#,###').format(budget.amount)} so\'m',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${budget.progressPercentage.toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: budget.isOverBudget ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: budget.progressPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    budget.isOverBudget ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date Range
            Text(
              '${DateFormat('dd/MM/yyyy').format(budget.startDate)} - ${DateFormat('dd/MM/yyyy').format(budget.endDate)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),

            if (budget.isOverBudget) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Budget ${NumberFormat('#,###').format(budget.remainingAmount.abs())} so\'m oshib ketdi',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
