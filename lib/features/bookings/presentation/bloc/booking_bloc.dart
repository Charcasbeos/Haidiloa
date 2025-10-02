import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/usecase/approve_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/check_in_booking_params.dart';
import 'package:haidiloa/features/bookings/domain/usecase/check_in_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/create_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/get_bookings_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/mark_no_show_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/get_bookings_params.dart';
import 'package:haidiloa/features/bookings/domain/usecase/params/reject_booking_params.dart';
import 'package:haidiloa/features/bookings/domain/usecase/reject_booking_usecase.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_event.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookingsUsecase getBookingsUsecase;
  final CreateBookingUsecase createBookingUsecase;
  final ApproveBookingUsecase approveBookingUsecase;
  final RejectBookingUsecase rejectBookingUsecase;
  final CheckInBookingUsecase checkInBookingUsecase;
  final MarkNoShowBookingUsecase markNoShowBookingUsecase;

  BookingBloc(
    this.getBookingsUsecase,
    this.createBookingUsecase,
    this.approveBookingUsecase,
    this.rejectBookingUsecase,
    this.checkInBookingUsecase,
    this.markNoShowBookingUsecase,
  ) : super(BookingInitial()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<CreateBookingEvent>(_onCreateBooking);
    on<ApproveBookingEvent>(_onApproveBooking);
    on<RejectBookingEvent>(_onRejectBooking);
    on<CheckInBookingEvent>(_onCheckInBooking);
    on<MarkNoShowBookingEvent>(_onMarkNoShowBooking);
  }

  Future<void> _onLoadBookings(
    LoadBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      print(event.date);
      print(event.status);
      final bookings = await getBookingsUsecase(
        params: GetBookingsParams(
          dateTime: event.date,
          status: event.status, // nếu có status
        ),
      );
      if (bookings is DataSuccess<List<BookingEntity>>) {
        emit(BookingLoaded(bookings.data!));
      } else if (bookings is DataError) {
        emit(BookingFailure("Khong lay duoc"));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final res = await createBookingUsecase(
        params: BookingEntity(
          id: 0,
          phone: event.phone,
          name: event.name,
          time: event.time,
          persons: event.persons,
          note: event.note ?? '',
          status: 'Pending',
          userId: '',
          createdAt: DateTime.now(),
          tableId: null,
          rejectReason: null,
        ),
      );
      if (res is DataSuccess) {
        emit(BookingSuccess('Tạo booking thành công'));
      } else {
        emit(BookingFailure('Tạo booking thất bại'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onApproveBooking(
    ApproveBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await approveBookingUsecase(params: event.bookingId);
      // reload
      add(LoadBookingsEvent(date: DateTime.now(), status: event.status));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onRejectBooking(
    RejectBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await rejectBookingUsecase(
        params: RejectBookingParams(
          bookingId: event.bookingId,
          reason: event.reason,
        ),
      );
      add(LoadBookingsEvent(date: DateTime.now(), status: event.status));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onCheckInBooking(
    CheckInBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await checkInBookingUsecase(
        params: CheckInBookingParams(
          bookingId: event.bookingId,
          tableId: event.tableId,
        ),
      );
      add(LoadBookingsEvent(date: DateTime.now(), status: event.status));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onMarkNoShowBooking(
    MarkNoShowBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await markNoShowBookingUsecase(params: event.bookingId);
      add(LoadBookingsEvent(date: DateTime.now(), status: event.status));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
