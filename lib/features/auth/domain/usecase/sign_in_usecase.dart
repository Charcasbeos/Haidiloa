import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/entities/sign_in.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';

class SignInUsecase implements Usecase<DataState<AuthEntity>, SignIn> {
  final AuthRepository _authRepository;

  SignInUsecase(this._authRepository);

  Future<DataState<AuthEntity>> call({required SignIn params}) async {
    return _authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
