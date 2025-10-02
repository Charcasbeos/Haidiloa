import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:haidiloa/features/bookings/data/mapper/booking_mapper.dart';
import 'package:haidiloa/features/bookings/data/model/booking_model.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remote;

  BookingRepositoryImpl(this._remote);

  @override
  Future<DataState<void>> approveBooking(int bookingId) async {
    try {
      await _remote.updateBooking(bookingId, {'status': 'Approved'});
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> checkInBooking({
    required int bookingId,
    required int tableId,
  }) async {
    try {
      await _remote.updateBooking(bookingId, {
        'status': 'Checkin',
        'table_id': tableId,
      });
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<int>> createBooking({
    required BookingEntity bookingEntity,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return DataError(UnknownException('Chưa đăng nhập'));
      }
      final id = await _remote.insertBooking(
        BookingModel(
          id: 0,
          phone: bookingEntity.phone,
          userId: user.id, // truyền nếu có
          name: bookingEntity.name,
          time: bookingEntity.time,
          createdAt: DateTime.now(),
          persons: bookingEntity.persons,
          tableId: 0,
          note: bookingEntity.note ?? '',
          rejectReason: '',
          status: 'Pending',
        ),
      );
      print(id);
      return DataSuccess(id);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteBooking({required int bookingId}) async {
    try {
      await _remote.deleteBooking(bookingId);
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<BookingEntity>> getBooking({required int bookingId}) async {
    try {
      final data = await _remote.getBookingById(bookingId);
      if (data == null) return DataError(UnknownException('Not found'));
      return DataSuccess(
        BookingMapper.toBookingEntity(BookingMapper.fromJson(data)),
      );
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> markNoShow(int bookingId) async {
    try {
      await _remote.updateBooking(bookingId, {'status': 'Missed'});
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> rejectBooking(int bookingId, String reason) async {
    try {
      await _remote.updateBooking(bookingId, {
        'status': 'Rejected',
        'reject_reason': reason,
      });
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> requestCancel(int bookingId) async {
    try {
      await _remote.updateBooking(bookingId, {'status': 'Cancel'});
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<BookingEntity>>> getBookings({
    required String status,
    required DateTime date,
  }) async {
    try {
      final data = await _remote.getBookings(status: status, date: date);
      final result = data
          .map(
            (json) =>
                BookingMapper.toBookingEntity(BookingMapper.fromJson(json)),
          )
          .toList();
      return DataSuccess(result);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<BookingEntity>>> getBookingsByUserId({
    required String userId,
  }) async {
    try {
      final data = await _remote.getBookingsByUserId(userId: userId);
      final result = data
          .map(
            (json) =>
                BookingMapper.toBookingEntity(BookingMapper.fromJson(json)),
          )
          .toList();
      return DataSuccess(result);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Stream<List<BookingEntity>> streamBookingsByUserId(String userId) {
    // Mỗi khi có event → gọi lại getBookingsByUserId để lấy list mới
    return _remote.streamBookingsByUserId(userId).asyncMap((_) async {
      final data = await _remote.getBookingsByUserId(userId: userId);
      final result = data
          .map(
            (json) =>
                BookingMapper.toBookingEntity(BookingMapper.fromJson(json)),
          )
          .toList();
      return (result);
    });
  }

  @override
  Future<DataState<void>> checkOutBooking({required int bookingId}) async {
    try {
      await _remote.updateBooking(bookingId, {'status': 'Checkout'});
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
