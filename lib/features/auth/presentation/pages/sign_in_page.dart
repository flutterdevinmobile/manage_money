import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              print('Error: ${state.message}');
            }
            if (state is AuthAuthenticated) {
              context.go('/main');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),

                // Auth form
                AuthForm(
                  isSignUp: false,
                  onSubmit: (email, password) {
                    context.read<AuthBloc>().add(
                          AuthSignInRequested(email: email, password: password),
                        );
                  },
                ),

                const SizedBox(height: 24),

                // Google sign in button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                      AuthGoogleSignInRequested(),
                                    );
                              },
                        icon: const Icon(Icons.login),
                        label: const Text(AppStrings.signInWithGoogle),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.go('/sign-up');
                  },
                  child: const Text(AppStrings.signUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
