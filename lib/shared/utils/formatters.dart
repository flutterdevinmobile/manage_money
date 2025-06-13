import 'package:intl/intl.dart';

/// Formatters following DRY principle
class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat('#,###');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String currency(double amount) {
    return '${_currencyFormat.format(amount)} so\'m';
  }

  static String date(DateTime date) {
    return _dateFormat.format(date);
  }

  static String dateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String percentage(double value) {
    return '${value.toInt()}%';
  }

  static String phoneNumber(String phone) {
    if (phone.length >= 9) {
      return '+998 ${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5, 7)} ${phone.substring(7)}';
    }
    return phone;
  }
}
