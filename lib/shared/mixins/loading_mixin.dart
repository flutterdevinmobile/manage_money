import 'package:flutter/material.dart';

/// Loading mixin following DRY principle
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  Future<void> executeWithLoading(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
    } finally {
      setLoading(false);
    }
  }
}
