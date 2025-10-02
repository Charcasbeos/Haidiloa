import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';

class GetDishUsecase implements Usecase<DataState<DishEntity>, int> {
  final DishRepository _dishRepository;
  GetDishUsecase(this._dishRepository);

  @override
  Future<DataState<DishEntity>> call({required int params}) {
    return _dishRepository.getDish(dishId: params);
  }
}
