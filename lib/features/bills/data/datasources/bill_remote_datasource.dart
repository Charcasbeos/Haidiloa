import 'package:supabase_flutter/supabase_flutter.dart';

class BillRemoteDataSource {
  final SupabaseClient supabase;
  BillRemoteDataSource(this.supabase);

  Future<Map<String, dynamic>?> getBillByName(String name) async {
    return await supabase.from('bills').select().eq('name', name).maybeSingle();
  }

  Future<Map<String, dynamic>?> getBillById(int id) async {
    return await supabase.from('bills').select().eq('id', id).maybeSingle();
  }

  Future<int> insertBill(String userId, double total, int tableId) async {
    final billInsert = await supabase
        .from('bills')
        .insert({
          'created_at': DateTime.now().toIso8601String(),
          'user_id': userId,
          'total': total,
          'table_id': tableId,
        })
        .select()
        .single();
    return billInsert['id'] as int;
  }

  Future<void> updateBill(int id, Map<String, dynamic> data) async {
    await supabase.from('bills').update(data).eq('id', id);
  }

  Future<void> updateBillPaymented(int billId, bool paymented) async {
    await supabase
        .from('bills')
        .update({'paymented': paymented})
        .eq('id', billId);
    // response.error check
  }

  Future<void> deleteBill(int id) async {
    await supabase.from('bills').delete().eq('id', id);
  }

  Future<void> requestPayment(int billId, double total) async {
    final response = await supabase
        .from('bills')
        .update({'request_payment': true, 'total': total}) // cập nhật trường
        .eq('id', billId)
        .select();

    if (response.isEmpty) {
      throw Exception("Không thể yêu cầu thanh toán");
    }
  }

  Future<List<Map<String, dynamic>>> getBills() async {
    return await supabase.from('bills').select();
  }

  Future<List<Map<String, dynamic>>> getBillsByUserId({
    required String userId,
  }) async {
    var query = supabase.from('bills').select().eq('user_id', userId);
    return await query;
  }

  Stream<List<Map<String, dynamic>>> streamBillsByUserId(String userId) {
    return supabase
        .from('bills')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId);
  }

  Future<void> updateBillTotal(int billId, double total) async {
    await supabase.from('bills').update({'total': total}).eq('id', billId);
  }
}
