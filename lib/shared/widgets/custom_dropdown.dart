import 'package:flutter/material.dart';

/// Custom dropdown following DRY principle
class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String labelText;
  final IconData? prefixIcon;
  final String Function(T) getDisplayText;
  final String? Function(T)? getSubtitle;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.getDisplayText,
    required this.onChanged,
    this.prefixIcon,
    this.getSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: getSubtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getDisplayText(item)),
                    if (getSubtitle!(item) != null)
                      Text(
                        getSubtitle!(item)!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                )
              : Text(getDisplayText(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
