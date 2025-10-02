import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingRepository {
  /// Lấy 1 booking theo id
  Future<DataState<BookingEntity>> getBooking({required int bookingId});

  /// Tạo booking mới – có thể truyền thêm params
  Future<DataState<int>> createBooking({required BookingEntity bookingEntity});

  /// Xóa booking (thường dùng khi booking chưa duyệt hoặc quyền admin)
  Future<DataState<void>> deleteBooking({required int bookingId});

  /// Lấy danh sách booking (có thể lọc theo status)
  Future<DataState<List<BookingEntity>>> getBookings({
    required String status,
    required DateTime date,
  });

  /// Lấy danh sách booking theo userId
  Future<DataState<List<BookingEntity>>> getBookingsByUserId({
    required String userId,
  });

  /// Lấy danh sách booking theo userId REALTIME
  Stream<List<BookingEntity>> streamBookingsByUserId(String userId);

  /// Khách gửi yêu cầu hủy booking
  Future<DataState<void>> requestCancel(int bookingId);

  /// Admin phê duyệt booking (status -> approved)
  Future<DataState<void>> approveBooking(int bookingId);

  /// Admin từ chối booking (status -> rejected + rejectReason)
  Future<DataState<void>> rejectBooking(int bookingId, String reason);

  /// Khi khách đến, gán bàn cho booking và chuyển status -> checked_in
  Future<DataState<void>> checkInBooking({
    required int bookingId,
    required int tableId,
  });

  /// Khi khách về, gán bàn cho booking và chuyển status -> checked_out
  Future<DataState<void>> checkOutBooking({required int bookingId});

  /// Đánh dấu khách không đến (no show)
  Future<DataState<void>> markNoShow(int bookingId);
}
