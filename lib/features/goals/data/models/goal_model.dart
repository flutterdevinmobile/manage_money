import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/enums/goal_type.dart';
import '../../domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.description,
    required super.targetAmount,
    required super.currentAmount,
    required super.type,
    required super.targetDate,
    required super.isCompleted,
    required super.createdAt,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      userId: data['userId'],
      name: data['name'],
      description: data['description'],
      targetAmount: data['targetAmount'].toDouble(),
      currentAmount: data['currentAmount'].toDouble(),
      type: GoalType.values.firstWhere((e) => e.name == data['type']),
      targetDate: (data['targetDate'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'type': type.name,
      'targetDate': Timestamp.fromDate(targetDate),
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      targetAmount: entity.targetAmount,
      currentAmount: entity.currentAmount,
      type: entity.type,
      targetDate: entity.targetDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
    );
  }
}
