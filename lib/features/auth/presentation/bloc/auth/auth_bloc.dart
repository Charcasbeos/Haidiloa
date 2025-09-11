// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:haidiloa/app/core/network/app_exception.dart';
// import 'package:haidiloa/app/core/state/data_state.dart';
// import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
// import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';
// import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
// import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';
// import 'package:haidiloa/features/auth/domain/usecase/sign_in_usecase.dart';
// import 'package:haidiloa/features/auth/domain/usecase/sign_out_usecase.dart';
// import 'package:haidiloa/features/auth/domain/usecase/sign_up_usecase.dart';
// import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_event.dart';
// import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SignInUsecase _signInUsecase;
//   final SignUpUsecase _signUpUsecase;
//   final SignOutUsecase _signOutUsecase;
//   final UserRepository _userRepository;
//   final AuthRepository _authRepository;
//   AuthBloc(
//     this._signInUsecase,
//     this._signUpUsecase,
//     this._userRepository,
//     this._signOutUsecase,
//     this._authRepository,
//   ) : super(AuthInitial()) {
//     on<CheckSessionEvent>((event, emit) async {
//       emit(AuthLoading());

//       // 1. Lấy thông tin auth hiện tại từ Supabase
//       final authResult = await _authRepository.getAuth();

//       if (authResult is DataSuccess<AuthEntity>) {
//         final userId = authResult.data!.id;

//         // 2. Dùng userId đó để lấy thông tin user từ bảng Users
//         final userResult = await _userRepository.getUser(userId: userId);

//         if (userResult is DataSuccess<UserEntity>) {
//           emit(UserSuccess(userResult.data!));
//         } else {
//           emit(AuthInitial()); // hoặc emit(AuthFailure(userResult.error!))
//         }
//       } else {
//         emit(AuthInitial()); // hoặc emit(AuthFailure(authResult.error!))
//       }
//     });

//     on<SignInEvent>((event, emit) async {
//       emit(AuthLoading());

//       // 1. Thực hiện đăng nhập
//       final signInResult = await _signInUsecase(params: event.signIn);

//       if (signInResult is DataSuccess<AuthEntity>) {
//         final auth = signInResult.data!;

//         // 2. Tạo user nếu chưa có trong bảng users
//         final createResult = await _userRepository.createUserIfNotExists(
//           userId: auth.id,
//           userEmail: auth.email,
//           createdAt: auth.created_at,
//         );

//         if (createResult is DataError) {
//           emit(SignInFailure(createResult.error!));
//           return;
//         }

//         // 3. Lấy thông tin User đầy đủ từ bảng users
//         final userResult = await _userRepository.getUser(userId: auth.id);

//         if (userResult is DataSuccess<UserEntity>) {
//           // Dang nhap thanh cong
//           emit(UserSuccess(userResult.data!));
//         } else if (userResult is DataError<UserEntity>) {
//           emit(SignInFailure(userResult.error!));
//         }
//       } else if (signInResult is DataError<AuthEntity>) {
//         if (signInResult.error != null &&
//             signInResult.error!.message.contains("Invalid login")) {
//           emit(
//             SignInFailure(UnknownException("Your email or password is wrong!")),
//           );
//         } else {
//           emit(
//             SignInFailure(
//               signInResult.error ??
//                   UnknownException(
//                     "Something went wrong. Please try again later.",
//                   ),
//             ),
//           );
//         }
//       }
//     });

//     on<SignUpEvent>((event, emit) async {
//       emit(AuthLoading());

//       final result = await _signUpUsecase(params: event.signUp);

//       if (result is DataSuccess<UserEntity>) {
//         // sign up thành công — ở đây bạn muốn trả về SignIn (hoặc AuthSignedUp)
//         print("👉 AuthBloc emit AuthSignedUp");

//         emit(SignInState("Sign up successful, please sign in."));
//       } else if (result is DataError<UserEntity>) {
//         emit(
//           SignUpFailure(
//             result.error ??
//                 UnknownException(
//                   "Something went wrong. Please try again later.",
//                 ),
//           ),
//         );
//       } else {
//         emit(
//           SignUpFailure(
//             UnknownException("Something went wrong. Please try again later."),
//           ),
//         );
//       }
//     });

//     on<SignOutEvent>((event, emit) async {
//       emit(AuthLoading());

//       final result = await _signOutUsecase(); // Không cần params

//       if (result is DataSuccess<void>) {
//         emit(
//           SignInState(""),
//         ); // Sau khi logout thì quay về trạng thái chưa đăng nhập
//       } else if (result is DataError<void>) {
//         emit(
//           AuthFailure(
//             result.error ??
//                 UnknownException(
//                   "Something went wrong. Please try again later.",
//                 ),
//           ),
//         );
//       }
//     });
//     on<ClearAuthErrorEvent>((event, emit) {
//       emit(AuthInitial());
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase _signInUsecase;
  final SignUpUsecase _signUpUsecase;
  final SignOutUsecase _signOutUsecase;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  AuthBloc(
    this._signInUsecase,
    this._signUpUsecase,
    this._userRepository,
    this._signOutUsecase,
    this._authRepository,
  ) : super(AuthInitial()) {
    /// ====================
    /// Check session (app start / reload)
    /// ====================
    on<CheckSessionEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final authResult = await _authRepository.getAuth();

        if (authResult is DataSuccess<AuthEntity>) {
          final userResult = await _userRepository.getUser(
            userId: authResult.data!.id,
          );

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
          final createResult = await _userRepository.createUserIfNotExists(
            userId: auth.id,
            userEmail: auth.email,
            createdAt: auth.created_at,
          );

          if (createResult is DataError) {
            emit(
              SignInFailure(
                createResult.error ?? UnknownException("Cannot create user."),
              ),
            );
            return;
          }

          // 3. Lấy thông tin user đầy đủ từ bảng users
          final userResult = await _userRepository.getUser(userId: auth.id);

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
