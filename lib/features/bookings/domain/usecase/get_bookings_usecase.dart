import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/get_bookings_params.dart';

class GetBookingsUsecase
    implements Usecase<DataState<List<BookingEntity>>, GetBookingsParams> {
  final BookingRepository _bookingRepository;
  GetBookingsUsecase(this._bookingRepository);

  @override
  Future<DataState<List<BookingEntity>>> call({
    required GetBookingsParams params,
  }) {
    return _bookingRepository.getBookings(
      status: params.status,
      date: params.dateTime,
    );
  }
}
