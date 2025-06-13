import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/enums/expense_category.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.description,
    required super.category,
    required super.type,
    required super.date,
    required super.createdAt,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      userId: data['userId'],
      amount: data['amount'].toDouble(),
      description: data['description'],
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == data['category'],
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
      ),
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'description': description,
      'category': category.name,
      'type': type.name,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      userId: entity.userId,
      amount: entity.amount,
      description: entity.description,
      category: entity.category,
      type: entity.type,
      date: entity.date,
      createdAt: entity.createdAt,
    );
  }
}
