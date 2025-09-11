import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Welcome")),

              // Submit button / loading indicator
              if (state is AuthLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                  child: const Text('Logout'),
                ),

              // Error message
              if (state is AuthFailure)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    state.error.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
