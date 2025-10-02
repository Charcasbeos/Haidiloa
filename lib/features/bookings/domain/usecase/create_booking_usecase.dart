import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';

import '../../../../app/core/usecases/base_usecase.dart';

class CreateBookingUsecase implements Usecase<DataState<int>, BookingEntity> {
  final BookingRepository _bookingRepository;
  CreateBookingUsecase(this._bookingRepository);

  @override
  Future<DataState<int>> call({required BookingEntity params}) {
    return _bookingRepository.createBooking(bookingEntity: params);
  }
}
