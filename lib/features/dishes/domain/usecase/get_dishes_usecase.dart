import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';

class GetDishesUsecase implements Usecase<DataState<List<DishEntity>>, void> {
  final DishRepository _dishRepository;
  GetDishesUsecase(this._dishRepository);

  @override
  Future<DataState<List<DishEntity>>> call({required void params}) {
    return _dishRepository.getDishes();
  }
}
