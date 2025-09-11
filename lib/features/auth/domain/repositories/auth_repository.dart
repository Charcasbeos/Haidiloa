import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<DataState<AuthEntity>> getAuth();
  Future<DataState<AuthEntity>> signIn({
    required String email,
    required String password,
  });
  Future<DataState<AuthEntity>> signUp({
    required String email,
    required String password,
  });
  Future<DataState<void>> signOut();
}
