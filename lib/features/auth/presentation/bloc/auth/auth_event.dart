import 'package:haidiloa/features/auth/domain/entities/sign_in.dart';
import 'package:haidiloa/features/auth/domain/entities/sign_up.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class CheckSessionEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final SignIn signIn;
  const SignInEvent(this.signIn);
}

class SignUpEvent extends AuthEvent {
  final SignUp signUp;
  const SignUpEvent(this.signUp);
}

class SignOutEvent extends AuthEvent {}
class ClearAuthErrorEvent extends AuthEvent {}
