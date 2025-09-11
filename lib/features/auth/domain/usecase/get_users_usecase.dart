import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';
import 'package:haidiloa/features/auth/domain/repositories/user_repository.dart';

class GetUsersUsecase implements Usecase<DataState<List<UserEntity>>, void> {
  final UserRepository _userRepository;
  GetUsersUsecase(this._userRepository);

  @override
  Future<DataState<List<UserEntity>>> call({required void params}) {
    return _userRepository.getUsers();
  }
}
