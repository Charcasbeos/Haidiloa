// features/dishes/data/repositories/dish_repository_impl.dart
import 'dart:typed_data';
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/data/datasources/dish_remote_datasource.dart';
import 'package:haidiloa/features/dishes/data/mapper/dish_mapper.dart';
import 'package:haidiloa/features/dishes/data/model/dish_model.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishRepositoryImpl implements DishRepository {
  final DishRemoteDataSource remoteDataSource;
  DishRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<void>> createDish({required DishEntity dishEntity}) async {
    try {
      // Map sang Model de giao tiep voi DB
      final dish = DishMapper.toDishModel(dishEntity);

      final exist = await remoteDataSource.getDishByName(dish.name);
      if (exist == null) {
        await remoteDataSource.insertDish({
          'name': dish.name,
          'image': dish.imageURL,
          'description': dish.description,
          'note': dish.note,
          'quantity': dish.quantity,
          'price': dish.price,
        });
        return const DataSuccess(null);
      } else {
        return DataError(RequestCancelledException('Dish already exists'));
      }
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteDish({required int dishId}) async {
    try {
      await remoteDataSource.deleteDish(dishId);
      return const DataSuccess(null);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<DishEntity>> getDish({required int dishId}) async {
    try {
      final response = await remoteDataSource.getDishById(dishId);
      if (response != null) {
        final model = DishModel.fromJson(response);
        return DataSuccess(DishMapper.toDishEntity(model));
      }
      return DataError(RequestCancelledException('Dish not found'));
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<DishEntity>>> getDishes() async {
    try {
      final response = await remoteDataSource.getDishes();
      final models = response.map((e) => DishModel.fromJson(e)).toList();
      final entities = DishMapper.toDishesEntityList(models);
      return DataSuccess(entities);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> updateDish({required DishEntity dishEntity}) async {
    try {
      // Map sang Model de giao tiep voi DB
      final dish = DishMapper.toDishModel(dishEntity);
      final exist = await remoteDataSource.getDishById(dish.id!);
      if (exist != null) {
        await remoteDataSource.updateDish(dish.id!, {
          'name': dish.name,
          'image': dish.imageURL,
          'description': dish.description,
          'note': dish.note,
          'quantity': dish.quantity,
          'price': dish.price,
        });
        return const DataSuccess(null);
      }
      return DataError(RequestCancelledException('Dish not found'));
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> uploadImage({required Uint8List data}) async {
    try {
      final publicUrl = await remoteDataSource.uploadImage(data);
      return DataSuccess(publicUrl);
    } on StorageException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
