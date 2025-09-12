import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/get_auth_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_in_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_out_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_up_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/user/create_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/user/get_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase _signInUsecase;
  final SignUpUsecase _signUpUsecase;
  final SignOutUsecase _signOutUsecase;
  final GetAuthUsecase _getAuthUsecase;
  final GetUserUsecase _getUserUsecase;
  final CreateUserUsecase _createUserUsecase;

  AuthBloc(
    this._signInUsecase,
    this._signUpUsecase,
    this._getAuthUsecase,
    this._signOutUsecase,
    this._getUserUsecase,
    this._createUserUsecase,
  ) : super(AuthInitial()) {
    /// ====================
    /// Check session (app start / reload)
    /// ====================
    on<CheckSessionEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final authResult = await _getAuthUsecase();

        if (authResult is DataSuccess<AuthEntity>) {
          final userResult = await _getUserUsecase(params: authResult.data!.id);

          if (userResult is DataSuccess<UserEntity>) {
            emit(UserSuccess(userResult.data!));
          } else {
            emit(AuthInitial());
          }
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthInitial());
      }
    });

    /// ====================
    /// Sign In
    /// ====================
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        // 1. Thực hiện sign in
        final signInResult = await _signInUsecase(params: event.signIn);
        debugPrint("signInResult runtimeType: ${signInResult.runtimeType}");
        if (signInResult is DataSuccess<AuthEntity>) {
          print("aaaaaaa ");
          final auth = signInResult.data!;

          // 2. Tạo user nếu chưa có
          final createResult = await _createUserUsecase(params: auth);

          if (createResult is DataError) {
            emit(
              SignInFailure(
                createResult.error ?? UnknownException("Cannot create user."),
              ),
            );
            return;
          }

          // 3. Lấy thông tin user đầy đủ từ bảng users
          final userResult = await _getUserUsecase(params: auth.id);

          if (userResult is DataSuccess<UserEntity>) {
            emit(UserSuccess(userResult.data!));
          } else {
            emit(
              SignInFailure(
                userResult.error ?? UnknownException("Cannot fetch user info."),
              ),
            );
          }
        } else if (signInResult is DataError<AuthEntity>) {
          final message = signInResult.error?.message ?? "";
          if (message.contains("Invalid login")) {
            emit(
              SignInFailure(
                UnknownException("Your email or password is incorrect!"),
              ),
            );
          } else {
            emit(
              SignInFailure(
                signInResult.error ??
                    UnknownException(
                      "Something went wrong. Please try again later.",
                    ),
              ),
            );
          }
        }
      } catch (e) {
        emit(SignInFailure(UnknownException("Unexpected error occurred: $e")));
      }
    });

    /// ====================
    /// Sign Up
    /// ====================
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final result = await _signUpUsecase(params: event.signUp);

        if (result is DataSuccess<AuthEntity>) {
          emit(SignInState("Sign up successful, please sign in."));
        } else if (result is DataError<AuthEntity>) {
          emit(
            SignUpFailure(
              result.error ??
                  UnknownException("Something went wrong. Please try again."),
            ),
          );
        } else {
          emit(
            SignUpFailure(
              UnknownException("Something went wrong. Please try again."),
            ),
          );
        }
      } catch (e) {
        emit(SignUpFailure(UnknownException("Unexpected error occurred: $e")));
      }
    });

    /// ====================
    /// Sign Out
    /// ====================
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final result = await _signOutUsecase();

        if (result is DataSuccess<void>) {
          emit(SignInState(""));
        } else if (result is DataError<void>) {
          emit(
            AuthFailure(
              result.error ??
                  UnknownException(
                    "Something went wrong. Please try again later.",
                  ),
            ),
          );
        }
      } catch (e) {
        emit(AuthFailure(UnknownException("Unexpected error occurred: $e")));
      }
    });

    /// ====================
    /// Clear Error
    /// ====================
    on<ClearAuthErrorEvent>((event, emit) {
      emit(AuthInitial());
    });
  }
}
