import 'package:get_it/get_it.dart';
import 'package:haidiloa/features/auth/data/data_sources/auth_service.dart';
import 'package:haidiloa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:haidiloa/features/auth/data/repositories/user_repository_impl.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/get_auth_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/user/create_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/user/get_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_in_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_out_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/auth/sign_up_usecase.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:haidiloa/features/dishes/data/repositories/dish_repository_impl.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';
import 'package:haidiloa/features/dishes/domain/usecase/create_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/upload_image_usecase.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Supabase client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ====================
  /// Auth
  /// ====================
  /* Auth service */
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<SupabaseClient>()),
  );

  /* Auth Repository */
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthService>(), sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<SupabaseClient>()),
  );
  /* Auth Usecases */
  sl.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetAuthUsecase>(
    () => GetAuthUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetUserUsecase>(
    () => GetUserUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(sl<UserRepository>()),
  );
  /* Auth Bloc */
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<SignInUsecase>(),
      sl<SignUpUsecase>(),
      sl<GetAuthUsecase>(),
      sl<SignOutUsecase>(),
      sl<GetUserUsecase>(),
      sl<CreateUserUsecase>(),
    ),
  );
  // ====================
  /// Dish
  /// ====================
  /* Dish Repository */
  sl.registerLazySingleton<DishRepository>(
    () => DishRepositoryImpl(sl<SupabaseClient>()),
  );
  /* Dish Usecases */
  sl.registerLazySingleton<CreateDishUsecase>(
    () => CreateDishUsecase(sl<DishRepository>()),
  );
  sl.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(sl<DishRepository>()),
  );
  /* Dish Bloc */
  sl.registerFactory<DishBloc>(
    () => DishBloc(sl<CreateDishUsecase>(), sl<UploadImageUsecase>()),
  );
}
