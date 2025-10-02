import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';

class MarkNoShowBookingUsecase implements Usecase<DataState<void>, int> {
  final BookingRepository _repo;
  MarkNoShowBookingUsecase(this._repo);

  @override
  Future<DataState<void>> call({required int params}) {
    return _repo.markNoShow(params);
  }
}
