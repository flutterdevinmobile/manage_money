import '../../../../shared/enums/goal_type.dart';

class GoalEntity {
  final String id;
  final String userId;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final GoalType type;
  final DateTime targetDate;
  final bool isCompleted;
  final DateTime createdAt;

  const GoalEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.type,
    required this.targetDate,
    required this.isCompleted,
    required this.createdAt,
  });

  double get remainingAmount => targetAmount - currentAmount;
  double get progressPercentage => (currentAmount / targetAmount * 100).clamp(0, 100);
  bool get isOverdue => !isCompleted && targetDate.isBefore(DateTime.now());
  
  int get daysRemaining {
    if (isCompleted) return 0;
    final now = DateTime.now();
    final difference = targetDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}
