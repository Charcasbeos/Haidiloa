import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';

class GetAuthUsecase implements Usecase<DataState<void>, void> {
  final AuthRepository _authRepository;
  GetAuthUsecase(this._authRepository);

  @override
  Future<DataState<void>> call({void params}) {
    return _authRepository.getAuth();
  }
}
