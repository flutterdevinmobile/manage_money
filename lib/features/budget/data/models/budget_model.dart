import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/enums/budget_period.dart';
import '../../../../shared/enums/expense_category.dart';
import '../../domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.amount,
    required super.spent,
    super.category,
    required super.period,
    required super.startDate,
    required super.endDate,
    required super.isActive,
    required super.createdAt,
  });

  factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel(
      id: doc.id,
      userId: data['userId'],
      name: data['name'],
      amount: data['amount'].toDouble(),
      spent: data['spent'].toDouble(),
      category: data['category'] != null
          ? ExpenseCategory.values.firstWhere((e) => e.name == data['category'])
          : null,
      period: BudgetPeriod.values.firstWhere((e) => e.name == data['period']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isActive: data['isActive'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'amount': amount,
      'spent': spent,
      'category': category?.name,
      'period': period.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BudgetModel.fromEntity(BudgetEntity entity) {
    return BudgetModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      amount: entity.amount,
      spent: entity.spent,
      category: entity.category,
      period: entity.period,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
