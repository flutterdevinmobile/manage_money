import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../inject.dart';
import '../../../../shared/enums/loan_status.dart';
import '../../../../shared/enums/loan_type.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/loan_entity.dart';
import '../bloc/loan_bloc.dart';
import '../bloc/loan_event.dart';
import '../bloc/loan_state.dart';

class AddLoanPage extends StatefulWidget {
  const AddLoanPage({super.key});

  @override
  State<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  LoanType _selectedType = LoanType.lent;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoanBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addLoan),
          actions: [
            BlocBuilder<LoanBloc, LoanState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state is LoanLoading ? null : _saveLoan,
                  child: const Text(AppStrings.save),
                );
              },
            ),
          ],
        ),
        body: BlocListener<LoanBloc, LoanState>(
          listener: (context, state) {
            if (state is LoanError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LoanOperationSuccess) {
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Loan Type
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Qarz turi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            RadioListTile<LoanType>(
                              title: Text(LoanType.lent.name),
                              value: LoanType.lent,
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                            RadioListTile<LoanType>(
                              title: Text(LoanType.borrowed.name),
                              value: LoanType.borrowed,
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Contact Name
                TextFormField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.contactName,
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.contacts),
                      onPressed: _selectContact,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kontakt nomini kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contact Phone
                TextFormField(
                  controller: _contactPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefon raqami',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: AppStrings.amount,
                    prefixIcon: Icon(Icons.attach_money),
                    suffixText: 'so\'m',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Summani kiriting';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Togri summa kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.description,
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Izoh kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Due Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(AppStrings.dueDate),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(_selectedDueDate)),
                  onTap: _selectDueDate,
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

  Future<void> _selectContact() async {
    final permission = await Permission.contacts.request();
    if (permission.isGranted) {
      try {
        final contacts = await FlutterContacts.getContacts();
        if (contacts.isNotEmpty && mounted) {
          final contact = await showDialog<Contact>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Kontakt tanlang'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(contact.phones?.isNotEmpty == true
                          ? contact.phones!.first.number ??
                              '' // <=== O'ZGARTIRILDI
                          : ''),
                      onTap: () => Navigator.pop(context, contact),
                    );
                  },
                ),
              ),
            ),
          );

          if (contact != null) {
            _contactNameController.text = contact.displayName ?? '';
            if (contact.phones?.isNotEmpty == true) {
              _contactPhoneController.text =
                  contact.phones!.first.number ?? ''; // <=== O'ZGARTIRILDI
            }
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kontaktlarni yuklashda xatolik: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kontaktlarga ruxsat berilmadi')),
      );
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _selectedDueDate = date;
      });
    }
  }

  void _saveLoan() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final loan = LoanEntity(
          id: '',
          userId: authState.user.id,
          contactName: _contactNameController.text,
          contactPhone: _contactPhoneController.text.isNotEmpty
              ? _contactPhoneController.text
              : null,
          amount: double.parse(_amountController.text),
          description: _descriptionController.text,
          type: _selectedType,
          status: LoanStatus.active,
          dueDate: _selectedDueDate,
          createdAt: DateTime.now(),
        );

        context.read<LoanBloc>().add(LoanAddRequested(loan: loan));
      }
    }
  }
}
