import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/enums/loan_status.dart';
import '../../../../shared/enums/loan_type.dart';
import '../../domain/entities/loan_entity.dart';

class LoanModel extends LoanEntity {
  const LoanModel({
    required super.id,
    required super.userId,
    required super.contactName,
    super.contactPhone,
    required super.amount,
    required super.description,
    required super.type,
    required super.status,
    required super.dueDate,
    required super.createdAt,
    super.paidAt,
  });

  factory LoanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoanModel(
      id: doc.id,
      userId: data['userId'],
      contactName: data['contactName'],
      contactPhone: data['contactPhone'],
      amount: data['amount'].toDouble(),
      description: data['description'],
      type: LoanType.values.firstWhere((e) => e.name == data['type']),
      status: LoanStatus.values.firstWhere((e) => e.name == data['status']),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      paidAt: data['paidAt'] != null 
          ? (data['paidAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'amount': amount,
      'description': description,
      'type': type.name,
      'status': status.name,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    };
  }

  factory LoanModel.fromEntity(LoanEntity entity) {
    return LoanModel(
      id: entity.id,
      userId: entity.userId,
      contactName: entity.contactName,
      contactPhone: entity.contactPhone,
      amount: entity.amount,
      description: entity.description,
      type: entity.type,
      status: entity.status,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
      paidAt: entity.paidAt,
    );
  }
}
