import 'package:flutter/material.dart';

/// Base form page that follows DRY principle
abstract class BaseFormPage extends StatefulWidget {
  final String title;
  final String? entityId;

  const BaseFormPage({
    super.key,
    required this.title,
    this.entityId,
  });
}

abstract class BaseFormPageState<T extends BaseFormPage> extends State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool get isEditing => widget.entityId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          buildSaveButton(),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildSaveButton();
  Widget buildBody();
  void onSave();

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
