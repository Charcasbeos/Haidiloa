import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';

class CreateDishUsecase implements Usecase<DataState<void>, DishEntity> {
  final DishRepository _dishRepository;
  CreateDishUsecase(this._dishRepository);

  @override
  Future<DataState<void>> call({required DishEntity params}) {
    return _dishRepository.createDish(dishEntity: params);
  }
}
