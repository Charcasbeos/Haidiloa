import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRemoteDataSource {
  final SupabaseClient supabase;
  OrderRemoteDataSource(this.supabase);

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    await supabase.from('orders').insert(orderData);
  }

  Future<void> updateOrder(int orderId, Map<String, dynamic> orderData) async {
    await supabase.from('orders').update(orderData).eq('id', orderId);
  }

  Future<void> deleteOrder(int orderId) async {
    await supabase.from('orders').delete().eq('id', orderId);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    return await supabase.from('orders').select();
  }

  /// Lấy tất cả orders theo billId, có thể sort theo tên món
  Future<List<Map<String, dynamic>>> getOrdersByBillId(int billId) async {
    final response = await supabase
        .from('orders')
        .select()
        .eq('bill_id', billId)
        .order('name', ascending: true); // sắp xếp A-Z theo tên món
    return response;
  }
}
