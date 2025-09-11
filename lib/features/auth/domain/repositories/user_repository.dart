import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<DataState<List<UserEntity>>> getUsers();
  Future<DataState<UserEntity>> getUser({required String userId});
  Future<DataState<void>> createUserIfNotExists({
    required String userId,
    required String userEmail,
    required DateTime createdAt,
  });
}
