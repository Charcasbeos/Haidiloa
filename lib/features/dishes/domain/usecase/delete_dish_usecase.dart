import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';

class DeleteDishUsecase implements Usecase<DataState<void>, String> {
  final DishRepository _dishRepository;
  DeleteDishUsecase(this._dishRepository);

  @override
  Future<DataState<void>> call({required String params}) {
    return _dishRepository.deleteDish(dishId: params);
  }
}
