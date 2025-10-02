import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingEntity> bookings;
  BookingLoaded(this.bookings);
}

class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}

/// Dùng khi tạo booking, update, approve… thành công
class BookingSuccess extends BookingState {
  final String message;
  BookingSuccess(this.message);
}
