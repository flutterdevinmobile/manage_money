enum GoalType {
  savings,
  debtPayoff,
  purchase,
  emergency,
  investment,
}

extension GoalTypeExtension on GoalType {
  String get name {
    switch (this) {
      case GoalType.savings:
        return 'Jamg\'arma';
      case GoalType.debtPayoff:
        return 'Qarz to\'lash';
      case GoalType.purchase:
        return 'Xarid';
      case GoalType.emergency:
        return 'Favqulodda holat';
      case GoalType.investment:
        return 'Investitsiya';
    }
  }

  String get description {
    switch (this) {
      case GoalType.savings:
        return 'Kelajak uchun pul jamg\'arish';
      case GoalType.debtPayoff:
        return 'Qarzlarni to\'lash';
      case GoalType.purchase:
        return 'Biror narsa sotib olish';
      case GoalType.emergency:
        return 'Favqulodda holatlar uchun';
      case GoalType.investment:
        return 'Investitsiya qilish';
    }
  }
}
