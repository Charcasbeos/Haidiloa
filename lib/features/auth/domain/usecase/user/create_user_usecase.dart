import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';

class CreateUserUsecase implements Usecase<DataState<void>, AuthEntity> {
  final UserRepository _userRepository;
  CreateUserUsecase(this._userRepository);
  @override
  Future<DataState<void>> call({required AuthEntity params}) {
    return _userRepository.createUserIfNotExists(
      userId: params.id,
      userEmail: params.email,
      createdAt: params.created_at,
    );
  }
}
