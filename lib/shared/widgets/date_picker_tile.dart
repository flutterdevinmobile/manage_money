import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date picker tile following DRY principle
class DatePickerTile extends StatelessWidget {
  final DateTime selectedDate;
  final String labelText;
  final IconData? icon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime) onDateSelected;

  const DatePickerTile({
    super.key,
    required this.selectedDate,
    required this.labelText,
    required this.onDateSelected,
    this.icon,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon ?? Icons.calendar_today),
      title: Text(labelText),
      subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
      onTap: () => _selectDate(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      onDateSelected(date);
    }
  }
}
