import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../inject.dart';
import '../../../../shared/enums/goal_type.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/goal_entity.dart';
import '../bloc/goal_bloc.dart';
import '../bloc/goal_event.dart';
import '../bloc/goal_state.dart';

class AddGoalPage extends StatefulWidget {
  final GoalEntity? goal;

  const AddGoalPage({super.key, this.goal});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  
  GoalType _selectedType = GoalType.savings;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _nameController.text = widget.goal!.name;
      _descriptionController.text = widget.goal!.description;
      _targetAmountController.text = widget.goal!.targetAmount.toString();
      _selectedType = widget.goal!.type;
      _targetDate = widget.goal!.targetDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GoalBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.goal == null ? 'Maqsad qoshish' : 'Maqsadni tahrirlash'),
          actions: [
            BlocBuilder<GoalBloc, GoalState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state is GoalLoading ? null : _saveGoal,
                  child: const Text('Saqlash'),
                );
              },
            ),
          ],
        ),
        body: BlocListener<GoalBloc, GoalState>(
          listener: (context, state) {
            if (state is GoalError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is GoalOperationSuccess) {
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Goal Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Maqsad nomi',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maqsad nomini kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Tavsif',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tavsifni kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Target Amount
                TextFormField(
                  controller: _targetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Maqsad summasi',
                    prefixIcon: Icon(Icons.attach_money),
                    suffixText: 'som',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Summani kiriting';
                    }
                    if (double.tryParse(value) == null) {
                      return 'To\'g\'ri summa kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Goal Type
                DropdownButtonFormField<GoalType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Maqsad turi',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: GoalType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.name),
                          Text(
                            type.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Target Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Maqsad sanasi'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(_targetDate)),
                  onTap: _selectTargetDate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date != null) {
      setState(() {
        _targetDate = date;
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final goal = GoalEntity(
          id: widget.goal?.id ?? '',
          userId: authState.user.id,
          name: _nameController.text,
          description: _descriptionController.text,
          targetAmount: double.parse(_targetAmountController.text),
          currentAmount: widget.goal?.currentAmount ?? 0,
          type: _selectedType,
          targetDate: _targetDate,
          isCompleted: widget.goal?.isCompleted ?? false,
          createdAt: widget.goal?.createdAt ?? DateTime.now(),
        );

        context.read<GoalBloc>().add(GoalAddRequested(goal: goal));
      }
    }
  }
}
