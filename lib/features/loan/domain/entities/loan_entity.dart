import '../../../../shared/enums/loan_status.dart';
import '../../../../shared/enums/loan_type.dart';

class LoanEntity {
  final String id;
  final String userId;
  final String contactName;
  final String? contactPhone;
  final double amount;
  final String description;
  final LoanType type;
  final LoanStatus status;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime? paidAt;

  const LoanEntity({
    required this.id,
    required this.userId,
    required this.contactName,
    this.contactPhone,
    required this.amount,
    required this.description,
    required this.type,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    this.paidAt,
  });
}
