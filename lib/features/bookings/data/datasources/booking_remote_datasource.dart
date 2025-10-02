import 'package:haidiloa/features/bookings/data/model/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRemoteDataSource {
  final SupabaseClient supabase;
  BookingRemoteDataSource(this.supabase);

  Future<Map<String, dynamic>?> getBookingByPhone(String phone) async {
    return await supabase
        .from('bookings')
        .select()
        .eq('phone', phone)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getBookingById(int id) async {
    return await supabase.from('bookings').select().eq('id', id).maybeSingle();
  }

  Future<int> insertBooking(BookingModel model) async {
    print(model.userId.toString());
    final bookingInsert = await supabase
        .from('bookings')
        .insert({
          'user_id': model.userId,
          'name': model.name, // sửa ở đây
          'phone': model.phone,
          'time': model.time.toIso8601String(),
          'persons': model.persons,
          'note': model.note,
          'status': model.status,
        })
        .select()
        .single();

    return bookingInsert['id'] as int;
  }

  Future<void> updateBooking(int id, Map<String, dynamic> data) async {
    await supabase.from('bookings').update(data).eq('id', id);
  }

  Future<void> deleteBooking(int id) async {
    await supabase.from('bookings').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getBookings({
    required String status,
    required DateTime date,
  }) async {
    var query = supabase.from('bookings').select();

    query = query.eq('status', status);

    // lọc theo ngày (so sánh yyyy-MM-dd)
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    query = query
        .gte('created_at', start.toIso8601String())
        .lt('created_at', end.toIso8601String());

    return await query;
  }

  Future<List<Map<String, dynamic>>> getBookingsByUserId({
    required String userId,
  }) async {
    var query = supabase.from('bookings').select().eq('user_id', userId);
    return await query;
  }

  Stream<List<Map<String, dynamic>>> streamBookingsByUserId(String userId) {
    return supabase
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId);
  }
}
