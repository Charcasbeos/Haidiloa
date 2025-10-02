import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/user/domain/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthEntity authEntity;
  const AuthSuccess(this.authEntity);
}
class UserSuccess extends AuthState {
  final UserEntity userEntity;
  const UserSuccess(this.userEntity);
}
class SignUpSuccess extends AuthState {}


class AuthFailure extends AuthState {
  final AppException error;
  const AuthFailure(this.error);
}

class SignInFailure extends AuthState {
  final AppException error;
  SignInFailure(this.error);
}

class SignUpFailure extends AuthState {
  final AppException error;
  SignUpFailure(this.error);
}

class SignInState extends AuthState {
  final String message;
  SignInState(this.message);
}
