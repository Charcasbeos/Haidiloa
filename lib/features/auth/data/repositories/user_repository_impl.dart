import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/data/mapper/user_mapper.dart';
import 'package:haidiloa/features/auth/data/model/user_model.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _supabase;
  UserRepositoryImpl(this._supabase);
  @override
  Future<DataState<void>> createUserIfNotExists({
    required String userId,
    required String userEmail,
    required DateTime createdAt,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response == null) {
        await _supabase.from('users').insert({
          'name': userEmail.split('@')[0],
          'email': userEmail,
          'birthday': createdAt.toIso8601String(),
          'phone': "unknow",
          'point': 0,
        });
      }
      return const DataSuccess(null);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<UserEntity>>> getUsers() async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('users')
          .select();
      if (response.isNotEmpty) {
        final List<UserModel> userModels = response
            .map((json) => UserModel.fromJson(json))
            .toList();
        final List<UserEntity> userEntities =
            UserMapper.toUserEntityListFromSupabase(userModels);
        return DataSuccess(userEntities);
      }
      return DataError(RequestCancelledException(""));
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<UserEntity>> getUser({required String userId}) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        final userModel = UserModel.fromJson(response);
        final userEntity = UserMapper.toUserEntityFromSupabase(userModel);
        return DataSuccess(userEntity);
      }
      return DataError(RequestCancelledException(""));
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
