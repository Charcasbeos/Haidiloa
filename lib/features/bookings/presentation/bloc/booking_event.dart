abstract class BookingEvent {}

class GetBookingsEvent extends BookingEvent {
  final String status; // pending, approved...
  GetBookingsEvent(this.status);
}

class LoadBookingsEvent extends BookingEvent {
  final DateTime date;
  final String status;
  LoadBookingsEvent({required this.date, required this.status});
}

class CreateBookingEvent extends BookingEvent {
  final String phone;
  final String name;
  final DateTime time;
  final int persons;
  final String? note;

  CreateBookingEvent({
    required this.phone,
    required this.name,
    required this.time,
    required this.persons,
    this.note,
  });
}

class ApproveBookingEvent extends BookingEvent {
  final int bookingId;
  final String status;

  ApproveBookingEvent(this.bookingId, this.status);
}

class RejectBookingEvent extends BookingEvent {
  final int bookingId;
  final String reason;
  final String status;

  RejectBookingEvent(this.bookingId, this.reason, this.status);
}

class CheckInBookingEvent extends BookingEvent {
  final int bookingId;
  final int tableId;
  final String status;

  CheckInBookingEvent({
    required this.bookingId,
    required this.tableId,
    required this.status,
  });
}

class MarkNoShowBookingEvent extends BookingEvent {
  final String status;
  final int bookingId;
  MarkNoShowBookingEvent(this.bookingId, this.status);
}
