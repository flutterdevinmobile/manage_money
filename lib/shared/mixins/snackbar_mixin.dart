import 'package:flutter/material.dart';

/// SnackBar mixin following DRY principle
mixin SnackBarMixin<T extends StatefulWidget> on State<T> {
  void showSuccessSnackBar(String message) {
    _showSnackBar(message, Colors.green);
  }

  void showErrorSnackBar(String message) {
    _showSnackBar(message, Colors.red);
  }

  void showInfoSnackBar(String message) {
    _showSnackBar(message, null);
  }

  void _showSnackBar(String message, Color? backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }
}
