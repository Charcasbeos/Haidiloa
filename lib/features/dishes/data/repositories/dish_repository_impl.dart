import 'dart:io';

import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishRepositoryImpl implements DishRepository {
  final SupabaseClient _supabase;
  DishRepositoryImpl(this._supabase);

  // Upload File
  Future<String?> uploadImage(File file) async {
    try {
      // Tạo tên file duy nhất
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload ảnh
      final uploadedPath = await _supabase.storage
          .from('avatars') // tên bucket
          .upload(fileName, file);

      // uploadedPath là đường dẫn trong bucket, ví dụ "123456789.jpg"
      // Lấy public URL
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(uploadedPath);

      return publicUrl;
    } on StorageException catch (e) {
      // lỗi từ supabase storage
      print('Upload error: ${e.message}');
      return null;
    } catch (e) {
      // lỗi khác
      print('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<DataState<void>> createDish({required DishEntity dish}) async {
    try {
      final response = await _supabase
          .from('dishes')
          .select()
          .eq('name', dish.name)
          .maybeSingle();
      if (response == null) {
        await _supabase.from('dishes').insert({
          'name': dish.name,
          'image': dish.imageURL,
          'description': dish.description,
          'note': dish.note,
          'quantity': dish.quantity,
          'price': dish.price,
        });
      }
      return const DataSuccess(null);
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
}
