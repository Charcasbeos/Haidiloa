import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';

class GetBookingsByUserIdUsecase
    implements Usecase<DataState<List<BookingEntity>>, String> {
  final BookingRepository _bookingRepository;
  GetBookingsByUserIdUsecase(this._bookingRepository);

  @override
  Future<DataState<List<BookingEntity>>> call({required String params}) {
    return _bookingRepository.getBookingsByUserId(userId: params);
  }
}
