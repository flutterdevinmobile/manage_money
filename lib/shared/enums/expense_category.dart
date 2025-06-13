import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  health,
  entertainment,
  bills,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.food:
        return 'Oziq-ovqat';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Xarid';
      case ExpenseCategory.health:
        return 'Sog\'liq';
      case ExpenseCategory.entertainment:
        return 'O\'yin-kulgi';
      case ExpenseCategory.bills:
        return 'To\'lovlar';
      case ExpenseCategory.other:
        return 'Boshqa';
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return AppColors.foodColor;
      case ExpenseCategory.transport:
        return AppColors.transportColor;
      case ExpenseCategory.shopping:
        return AppColors.shoppingColor;
      case ExpenseCategory.health:
        return AppColors.healthColor;
      case ExpenseCategory.entertainment:
        return AppColors.entertainmentColor;
      case ExpenseCategory.bills:
        return AppColors.billsColor;
      case ExpenseCategory.other:
        return AppColors.otherColor;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.health:
        return Icons.local_hospital;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.bills:
        return Icons.receipt;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }
}
