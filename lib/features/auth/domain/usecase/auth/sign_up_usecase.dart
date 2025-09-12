import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/entities/sign_up.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';

class SignUpUsecase implements Usecase<DataState<AuthEntity>, SignUp> {
  final AuthRepository _authRepository;
  SignUpUsecase(this._authRepository);

  @override
  Future<DataState<AuthEntity>> call({required SignUp params}) {
    return _authRepository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}
