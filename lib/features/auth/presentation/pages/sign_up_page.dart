import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              print(state.message);
            }
            if (state is AuthAuthenticated) {
              User user = FirebaseAuth.instance.currentUser!;
              context.go('/main');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ro‘yxatdan o‘tish',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                AuthForm(
                  isSignUp: true,
                  onSubmit: (email, password) {
                    context.read<AuthBloc>().add(
                          AuthSignUpRequested(email: email, password: password),
                        );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/sign-up'),
                  child: const Text("Akkauntingiz bormi? Kirish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
