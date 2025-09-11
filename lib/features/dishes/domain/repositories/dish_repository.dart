import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';

abstract class DishRepository {
  Future<DataState<DishEntity>> getDish({required String dishId});
  Future<DataState<DishEntity>> updateDish({required DishEntity dish});
  Future<DataState<void>> createDish({required DishEntity dish});
  Future<DataState<void>> deleteDish({required String dishId});
  Future<DataState<List<DishEntity>>> getDishes();
}
