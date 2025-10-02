import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/check_in_booking_params.dart';

class CheckInBookingUsecase
    implements Usecase<DataState<void>, CheckInBookingParams> {
  final BookingRepository _repo;
  CheckInBookingUsecase(this._repo);

  @override
  Future<DataState<void>> call({required CheckInBookingParams params}) {
    return _repo.checkInBooking(
      bookingId: params.bookingId,
      tableId: params.tableId,
    );
  }
}
