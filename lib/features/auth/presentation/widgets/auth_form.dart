import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class AuthForm extends StatefulWidget {
  final bool isSignUp;
  final Function(String email, String password) onSubmit;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: AppStrings.email,
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email kiriting';
              }
              if (!value.contains('@')) {
                return AppStrings.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: AppStrings.password,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Parol kiriting';
              }
              if (value.length < 6) {
                return AppStrings.weakPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm password field (only for sign up)
          if (widget.isSignUp) ...[
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              decoration: const InputDecoration(
                labelText: AppStrings.confirmPassword,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parolni tasdiqlang';
                }
                if (value != _passwordController.text) {
                  return 'Parollar mos kelmaydi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 24),

          // Submit button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmit(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          }
                        },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.isSignUp
                          ? AppStrings.signUp
                          : AppStrings.signIn),
                ),
              );
            },
          ),

          if (!widget.isSignUp) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go("/reset-password");
              },
              child: const Text(AppStrings.forgotPassword),
            ),
          ],
        ],
      ),
    );
  }
}
