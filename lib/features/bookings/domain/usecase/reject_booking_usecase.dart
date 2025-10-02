import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/reject_booking_params.dart';

class RejectBookingUsecase
    implements Usecase<DataState<void>, RejectBookingParams> {
  final BookingRepository _repo;
  RejectBookingUsecase(this._repo);

  @override
  Future<DataState<void>> call({required RejectBookingParams params}) {
    return _repo.rejectBooking(params.bookingId, params.reason);
  }
}
