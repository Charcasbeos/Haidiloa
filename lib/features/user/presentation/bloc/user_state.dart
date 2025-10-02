import 'package:equatable/equatable.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/user/domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserEntity user;
  final List<BookingEntity> bookings;
  final List<BillEntity> bills;
  final List<BookingEntity>? bookingNow;
  final int? tableId;

  const UserLoaded(
    this.user,
    this.bookings,
    this.bills,
    this.bookingNow,
    this.tableId,
  );

  @override
  List<Object?> get props => [user, bookings, bills, tableId];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
