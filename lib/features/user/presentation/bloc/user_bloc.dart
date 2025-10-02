import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';
import 'package:haidiloa/features/auth/domain/usecase/get_auth_usecase.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bills_by_user_id_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/realtime/stream_bills_by_user_id_usecase.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/domain/usecase/get_bookings_by_user_id_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/realtime/stream_bookings_by_user_id_usecase.dart';
import 'package:haidiloa/features/user/domain/usecase/get_user_usecase.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_event.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase _getUserUsecase;
  final GetAuthUsecase _getAuthUsecase;
  final GetBookingsByUserIdUsecase _getBookingsByUserIdUsecase;
  final GetBillsByUserIdUsecase _getBillsByUserIdUsecase;
  final StreamBookingsByUserIdUsecase _streamBookingsByUserIdUsecase;
  final StreamBillsByUserIdUsecase _streamBillsByUserIdUsecase;

  StreamSubscription<List<BookingEntity>>? _bookingSub;
  StreamSubscription<List<BillEntity>>? _billSub;

  UserBloc(
    this._getUserUsecase,
    this._getAuthUsecase,
    this._getBookingsByUserIdUsecase,
    this._getBillsByUserIdUsecase,
    this._streamBookingsByUserIdUsecase,
    this._streamBillsByUserIdUsecase,
  ) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<RefreshUserEvent>(_onRefreshUser);
    on<ClearUserEvent>(_onClearUser);
    on<UpdateTableIdUserEvent>(_onUpdateTableId);
  }
  // Định nghĩa thứ tự ưu tiên
  int _billStatusPriority(BillEntity bill) {
    // paymented = đã thanh toán
    if (bill.paymented == true) return 2; // approved
    if (bill.requestPayment == true) return 1; // request
    return 0; // pending
  }

  int _bookingStatusPriority(BookingEntity b) {
    switch (b.status) {
      case "Pending":
        return 0;
      case "Approved":
        return 1;
      case "Checkin":
        return 2;
      case "Missed":
        return 3;
      case "Reject":
        return 4;
      default:
        return 5; // unknown
    }
  }

  int _currentTableId = -1;
  void _sortBookings(List<BookingEntity> bookings) {
    bookings.sort((a, b) {
      final statusCompare = _bookingStatusPriority(
        a,
      ).compareTo(_bookingStatusPriority(b));
      if (statusCompare != 0) return statusCompare;

      // cùng trạng thái -> sắp xếp theo thời gian

      return a.time.compareTo(b.time);
    });
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final auth = await _getAuthUsecase();
    if (auth is! DataSuccess<AuthEntity>) {
      emit(UserError("Chưa đăng nhập"));
      return;
    }

    final userId = auth.data!.id;
    final userRes = await _getUserUsecase(params: userId);
    if (userRes is! DataSuccess) {
      emit(UserError("Không tìm thấy dữ liệu của user"));
      return;
    }

    final user = userRes.data!;

    final bookingsRes = await _getBookingsByUserIdUsecase(params: user.id);
    final billsRes = await _getBillsByUserIdUsecase(params: user.id);
    List<BookingEntity> bookings = bookingsRes.maybeWhen(
      data: (d) => d,
      orElse: () => [],
    );
    List<BillEntity> bills = billsRes.maybeWhen(
      data: (d) => d,
      orElse: () => [],
    );
    // Sắp xếp bills: pending -> requestPayment -> approved
    bills.sort(
      (a, b) => _billStatusPriority(a).compareTo(_billStatusPriority(b)),
    );
    // Sap xep booking
    _sortBookings(bookings);
    // Tim bookings trung voi ngay dang nhap
    final today = DateTime.now();

    final todayBookings = bookings.where((b) {
      final start = b.time;
      return start.year == today.year &&
          start.month == today.month &&
          start.day == today.day;
    }).toList();
    // Kiem tra co booking nao trung voi hom nay va da duoc checkin thi update tableId cho bill
    // tính _currentTableId lần đầu
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      _currentTableId = currentState.tableId!;
    }

    for (var booking in bookings) {
      if (booking.status == "Checkin" &&
          booking.time.year == today.year &&
          booking.time.month == today.month &&
          booking.time.day == today.day) {
        _currentTableId = booking.tableId!;
      }
    }
    // Lần đầu emit
    emit(UserLoaded(user, bookings, bills, todayBookings, _currentTableId));

    final mergedStream = Rx.combineLatest2(
      _streamBookingsByUserIdUsecase(params: userId),
      _streamBillsByUserIdUsecase(params: userId),
      (List<BookingEntity> bookings, List<BillEntity> bills) {
        // sắp xếp bills ngay trong stream
        bills.sort(
          (a, b) => _billStatusPriority(a).compareTo(_billStatusPriority(b)),
        );
        // Sap xep booking
        _sortBookings(bookings);
        return [bookings, bills];
      },
    );

    await emit.forEach<List<dynamic>>(
      mergedStream,
      onData: (data) {
        final bookings = data[0] as List<BookingEntity>;
        final bills = data[1] as List<BillEntity>;
        // Tim nhung booking cua ngay hien tai
        final todayBookings = bookings.where((b) {
          final start = b.time;
          return start.year == today.year &&
              start.month == today.month &&
              start.day == today.day;
        }).toList();
        // tính lại tableId nếu có booking checkin hôm nay
        int? streamTableId;
        // Kiem tra co booking nao trung voi hom nay va da duoc checkin thi update tableId cho bill
        for (var booking in bookings) {
          if (booking.status == "Checkin" &&
              booking.time.year == today.year &&
              booking.time.month == today.month &&
              booking.time.day == today.day) {
            streamTableId = booking.tableId!;
          }
        }
        if (streamTableId != null) {
          _currentTableId = streamTableId;
        }

        return UserLoaded(
          user,
          bookings,
          bills,
          todayBookings,
          _currentTableId,
        );
      },
    );
  }

  Future<void> _onUpdateTableId(
    UpdateTableIdUserEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final s = state as UserLoaded;
      print("update: " + event.tableId.toString());
      _currentTableId = event.tableId; // lưu lại để stream không ghi đè
      emit(
        UserLoaded(s.user, s.bookings, s.bills, s.bookingNow, _currentTableId),
      );
    }
  }

  @override
  Future<void> close() {
    _bookingSub?.cancel();
    _billSub?.cancel();
    return super.close();
  }

  Future<void> _onRefreshUser(
    RefreshUserEvent event,
    Emitter<UserState> emit,
  ) async {
    add(LoadUserEvent());
  }

  Future<void> _onClearUser(
    ClearUserEvent event,
    Emitter<UserState> emit,
  ) async {
    // huỷ stream subscription để tránh nhận dữ liệu cũ
    await _bookingSub?.cancel();
    await _billSub?.cancel();
    _bookingSub = null;
    _billSub = null;

    // reset biến cục bộ
    _currentTableId = -1; // hoặc null tuỳ bạn
    // nếu có giữ billId thì reset tương tự

    emit(UserInitial());
  }
}
