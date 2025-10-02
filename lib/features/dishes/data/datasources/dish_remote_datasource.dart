// features/dishes/data/datasources/dish_remote_datasource.dart
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishRemoteDataSource {
  final SupabaseClient supabase;
  DishRemoteDataSource(this.supabase);

  Future<Map<String, dynamic>?> getDishByName(String name) async {
    return await supabase.from('dishes').select().eq('name', name).maybeSingle();
  }

  Future<Map<String, dynamic>?> getDishById(int id) async {
    return await supabase.from('dishes').select().eq('id', id).maybeSingle();
  }

  Future<void> insertDish(Map<String, dynamic> data) async {
    await supabase.from('dishes').insert(data);
  }

  Future<void> updateDish(int id, Map<String, dynamic> data) async {
    await supabase.from('dishes').update(data).eq('id', id);
  }

  Future<void> deleteDish(int id) async {
    await supabase.from('dishes').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getDishes() async {
    return await supabase.from('dishes').select();
  }

  Future<String> uploadImage(Uint8List data) async {
    final bucket = "haidiloa";
    final filePath = 'dishes/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await supabase.storage.from(bucket).uploadBinary(filePath, data);
    return supabase.storage.from(bucket).getPublicUrl(filePath);
  }
}
