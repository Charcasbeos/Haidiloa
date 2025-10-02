import 'dart:typed_data';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';

abstract class DishRepository {
  Future<DataState<DishEntity>> getDish({required int dishId});
  Future<DataState<void>> updateDish({required DishEntity dishEntity});
  Future<DataState<void>> createDish({required DishEntity dishEntity});
  Future<DataState<String>> uploadImage({required Uint8List data});
  Future<DataState<void>> deleteDish({required int dishId});
  Future<DataState<List<DishEntity>>> getDishes();
}
