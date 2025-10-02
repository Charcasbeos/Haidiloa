import 'package:haidiloa/app/core/usecases/stream_usecase.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';

class StreamBookingsByUserIdUsecase
    implements StreamUsecase<List<BookingEntity>, String> {
  final BookingRepository repo;

  StreamBookingsByUserIdUsecase(this.repo);

  @override
  Stream<List<BookingEntity>> call({required String params}) {
    return repo.streamBookingsByUserId(params);
  }
}
