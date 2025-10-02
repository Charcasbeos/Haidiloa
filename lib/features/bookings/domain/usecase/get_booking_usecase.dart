import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';

class GetBookingUsecase {
  final BookingRepository repository; // repo của bill

  GetBookingUsecase(this.repository);

  Future<DataState<BookingEntity>> call(int bookingId) async {
    return await repository.getBooking(bookingId: bookingId);
  }
}
