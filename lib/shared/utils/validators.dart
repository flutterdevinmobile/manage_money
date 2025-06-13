/// Validators following DRY principle
class Validators {
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu maydon'} to\'ldirilishi shart';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email kiriting';
    }
    if (!value.contains('@')) {
      return 'Noto\'g\'ri email format';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parol kiriting';
    }
    if (value.length < 6) {
      return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Summani kiriting';
    }
    if (double.tryParse(value) == null) {
      return 'To\'g\'ri summa kiriting';
    }
    if (double.parse(value) <= 0) {
      return 'Summa 0 dan katta bo\'lishi kerak';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (value.length < 9) {
      return 'To\'g\'ri telefon raqam kiriting';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Parolni tasdiqlang';
    }
    if (value != originalPassword) {
      return 'Parollar mos kelmaydi';
    }
    return null;
  }
}
