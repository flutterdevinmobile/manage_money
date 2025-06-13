import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/goal_entity.dart';

class GoalItem extends StatelessWidget {
  final GoalEntity goal;
  final Function(double) onAddMoney;

  const GoalItem({
    super.key,
    required this.goal,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        goal.type.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (goal.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Bajarildi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                else if (goal.isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Muddati o\'tgan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            Text(
              goal.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${NumberFormat('#,###').format(goal.currentAmount)} / ${NumberFormat('#,###').format(goal.targetAmount)} so\'m',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${goal.progressPercentage.toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: goal.isCompleted ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.progressPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    goal.isCompleted ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Target Date and Days Remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maqsad sanasi: ${DateFormat('dd/MM/yyyy').format(goal.targetDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (!goal.isCompleted && !goal.isOverdue)
                  Text(
                    '${goal.daysRemaining} kun qoldi',
                    style: TextStyle(
                      fontSize: 12,
                      color: goal.daysRemaining < 30 ? Colors.orange : Colors.grey[600],
                      fontWeight: goal.daysRemaining < 30 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),

            if (!goal.isCompleted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddMoneyDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Pul qo\'shish'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Qolgan: ${NumberFormat('#,###').format(goal.remainingAmount)} so\'m',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pul qo\'shish'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Summa',
            suffixText: 'so\'m',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                onAddMoney(amount);
              }
            },
            child: const Text('Qo\'shish'),
          ),
        ],
      ),
    );
  }
}
