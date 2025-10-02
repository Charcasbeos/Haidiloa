import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/user/domain/entities/user_entity.dart';
import 'package:haidiloa/features/user/domain/repositories/user_repository.dart';

class GetUserUsecase implements Usecase<DataState<UserEntity>, String> {
  final UserRepository _userRepository;
  GetUserUsecase(this._userRepository);
  @override
  Future<DataState<UserEntity>> call({required String params}) {
    return _userRepository.getUser(userId: params);
  }
}
