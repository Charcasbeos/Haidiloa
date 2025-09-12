import 'dart:typed_data';

import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/permission/permission_service.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishRepositoryImpl implements DishRepository {
  final SupabaseClient _supabase;
  final permissionService = PermissionService();
  DishRepositoryImpl(this._supabase);

  @override
  Future<DataState<void>> createDish({required DishEntity dish}) async {
    try {
      // Kiem tra co ton tai mon an voi name tuong tu hay chua
      final response = await _supabase
          .from('dishes')
          .select()
          .eq('name', dish.name)
          .maybeSingle();

      if (response == null) {
        // Theem dish moi voi image vua duoc them vao storage
        await _supabase.from('dishes').insert({
          'name': dish.name,
          'image': dish.imageURL,
          'description': dish.description,
          'note': dish.note,
          'quantity': dish.quantity,
          'price': dish.price,
        });
        // Trả về success
        return const DataSuccess(null);
      } else {
        // Đã tồn tại món
        return DataError(RequestCancelledException('Dish already exists'));
      }
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteDish({required String dishId}) {
    // TODO: implement deleteDish
    throw UnimplementedError();
  }

  @override
  Future<DataState<DishEntity>> getDish({required String dishId}) {
    // TODO: implement getDish
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<DishEntity>>> getDishes() {
    // TODO: implement getDishes
    throw UnimplementedError();
  }

  @override
  Future<DataState<DishEntity>> updateDish({required DishEntity dish}) {
    // TODO: implement updateDish
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> uploadImage({required Uint8List data}) async {
    try {
      final bucket = "haidiloa";
      final filePath = 'dishes/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // truyền data chứ không phải image
      await _supabase.storage.from(bucket).uploadBinary(filePath, data);

      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);
      return DataSuccess(publicUrl);
    } on StorageException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
