import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/data/data_sources/auth_service.dart';
import 'package:haidiloa/features/auth/data/mapper/auth_mapper.dart';
import 'package:haidiloa/features/auth/data/model/auth_model.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final SupabaseClient _supabase;
  AuthRepositoryImpl(this._authService, this._supabase);
  @override
  Future<DataState<AuthEntity>> getAuth() async {
    try {
      final session = _authService.currentSession;
      final user = session?.user;
      if (user == null) {
        return DataError(UnauthorizedException());
      }
      final authModel = AuthModel.fromSupabase(user);
      final authEntity = AuthMapper.toAuthEntityFromSupabase(authModel);
      return DataSuccess(authEntity);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  // @override
  // Future<DataState<AuthEntity>> signIn({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await _authService.signIn(email, password);
  //     final user = response.user;
  //     if (user == null) {
  //       return DataError(AuthAppException("No user returned from Supabase"));
  //     }
  //     // Đọc từ user cuả Supabase gắn vào userModel
  //     final authModel = AuthModel.fromSupabase(user);
  //     final userEntity = UserMapper.toUserEntityFromSupabase(authModel);
  //     // Sử dụng userEntity để thêm vào bảng Users nếu là đăng nhập lần đầu
  //     await createUserIfNotExists(userEntity: userEntity);
  //     // Đọc lại dữ liệu user từ Users với dữ liệu của mình, gán vào
  //     return DataSuccess(userEntity);
  //   } on AuthException catch (e) {
  //     return DataError(AuthAppException(e.message));
  //   } catch (e) {
  //     return DataError(UnknownException(e.toString()));
  //   }
  // }

  @override
  Future<DataState<AuthEntity>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signUp(email, password);
      final user = response.user;
      if (user == null) {
        return DataError(
          AuthAppException("Sign up fail returned from Supabase"),
        );
      }
      final authModel = AuthModel.fromSupabase(user);
      final authEntity = AuthMapper.toAuthEntityFromSupabase(authModel);
      return DataSuccess(authEntity);
    } on AuthException catch (e) {
      return DataError(AuthAppException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return const DataSuccess(null);
    } on AuthException catch (e) {
      return DataError(AuthAppException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<AuthEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signIn(email, password);
      final user = response.user;
      if (user == null) {
        return DataError(AuthAppException("No user returned from Supabase"));
      }
      // Đọc từ user cuả Supabase gắn vào userModel
      final authModel = AuthModel.fromSupabase(user);
      final authEntity = AuthMapper.toAuthEntityFromSupabase(authModel);

      return DataSuccess(authEntity);
    } on AuthException catch (e) {
      return DataError(AuthAppException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
