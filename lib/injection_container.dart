import 'package:get_it/get_it.dart';
import 'package:haidiloa/features/auth/data/data_sources/auth_service.dart';
import 'package:haidiloa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:haidiloa/features/auth/data/repositories/user_repository_impl.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';
import 'package:haidiloa/features/auth/domain/usecase/create_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/get_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/get_users_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Supabase client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth service
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<SupabaseClient>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthService>(), sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<SupabaseClient>()),
  );

  // Usecases
  sl.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetUserUsecase>(
    () => GetUserUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<GetUsersUsecase>(
    () => GetUsersUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(sl<UserRepository>()),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<SignInUsecase>(),
      sl<SignUpUsecase>(),
      sl<UserRepository>(),
      sl<SignOutUsecase>(),
      sl<AuthRepository>(),
    ),
  );
}
