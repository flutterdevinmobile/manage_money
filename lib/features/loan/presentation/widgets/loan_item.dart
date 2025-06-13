import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/enums/loan_status.dart';
import '../../../../shared/enums/loan_type.dart';
import '../../domain/entities/loan_entity.dart';

class LoanItem extends StatelessWidget {
  final LoanEntity loan;
  final VoidCallback onMarkPaid;

  const LoanItem({
    super.key,
    required this.loan,
    required this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = loan.status == LoanStatus.active &&
        loan.dueDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          child: Icon(
            loan.type == LoanType.lent ? Icons.call_made : Icons.call_received,
            color: Colors.white,
          ),
        ),
        title: Text(loan.contactName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loan.description),
            Text(
              'Muddat: ${DateFormat('dd/MM/yyyy').format(loan.dueDate)}',
              style: TextStyle(
                fontSize: 12,
                color: isOverdue ? Colors.red : Colors.grey[600],
              ),
            ),
            if (loan.contactPhone != null)
              Text(
                loan.contactPhone!,
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
                '${NumberFormat('#,###').format(loan.amount)} so\'m',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      loan.type == LoanType.lent ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOverdue ? 'Muddati o\'tgan' : loan.status.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              if (loan.status == LoanStatus.active)
                TextButton(
                  onPressed: onMarkPaid,
                  child: const Text('To\'landi'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    final isOverdue = loan.status == LoanStatus.active &&
        loan.dueDate.isBefore(DateTime.now());

    if (isOverdue) return Colors.red;

    switch (loan.status) {
      case LoanStatus.active:
        return Colors.orange;
      case LoanStatus.paid:
        return Colors.green;
      case LoanStatus.overdue:
        return Colors.red;
    }
  }
}
