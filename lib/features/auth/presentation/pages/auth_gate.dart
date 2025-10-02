import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/admin/presentation/pages/admin_page.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_state.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_bloc.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_event.dart';
import 'package:haidiloa/features/user/presentation/pages/home_page.dart';
import 'package:haidiloa/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:haidiloa/features/auth/presentation/widgets/sign_up_form.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showSignIn = true; // mặc định là Sign In

  void toggleForm() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  Widget _buildAuthForm(Widget form, {bool isLoading = false}) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Column(children: [form]),
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _homeByRole(String role) {
    if (role.toLowerCase() == 'admin') {
      return AdminPage();
    }
    return HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          context.read<UserBloc>().add(LoadUserEvent());
          return _homeByRole(state.userEntity.role);
        }

        if (state is SignInState || showSignIn) {
          return _buildAuthForm(
            SignInForm(onToggle: toggleForm),
            isLoading: state is AuthLoading,
          );
        }

        return _buildAuthForm(
          SignUpForm(onToggle: toggleForm),
          isLoading: state is AuthLoading,
        );
      },
    );
  }
}
