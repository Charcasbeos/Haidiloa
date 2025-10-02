import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bills_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/request_payment_params.dart';
import 'package:haidiloa/features/bills/domain/usecase/request_payment_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/update_bill_payment.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_event.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_state.dart';
import 'package:haidiloa/features/bookings/domain/usecase/check_out_booking.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/domain/usecase/get_orders_by_bill_id_usecase.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final GetOrdersByBillIdUsecase _getOrdersByBillIdUsecase;
  final GetBillUsecase _getBillUsecase;
  final GetBillsUsecase _getBillsUsecase;
  final RequestPaymentUsecase _requestPaymentUsecase;
  final UpdateBillPaymentedUsecase _updateBillPaymentedUsecase;
  final CheckOutBookingUseCase _checkOutBookingUseCase;

  BillBloc(
    this._getOrdersByBillIdUsecase,
    this._requestPaymentUsecase,
    this._getBillUsecase,
    this._getBillsUsecase,
    this._updateBillPaymentedUsecase,
    this._checkOutBookingUseCase,
  ) : super(BillInitial()) {
    on<LoadBillOrdersEvent>(_onLoadOrders);
    on<RequestPaymentEvent>(_onRequestPayment);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<GetBillsEvent>(_onGetBills);
  }
  int _billStatusPriority(BillEntity bill) {
    // paymented = đã thanh toán
    if (bill.paymented == true) return 2; // approved
    if (bill.requestPayment == true) return 1; // request
    return 0; // pending
  }

  Future<void> _onLoadOrders(
    LoadBillOrdersEvent event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());

    // Lấy bill
    final billRes = await _getBillUsecase(event.billId);
    if (billRes is! DataSuccess<BillEntity>) {
      emit(BillFailure('Không tìm thấy hóa đơn'));
      return;
    }
    final bill = billRes.data!;

    // Lấy orders
    final ordersRes = await _getOrdersByBillIdUsecase(event.billId);
    if (ordersRes is! DataSuccess<List<OrderEntity>>) {
      emit(BillFailure(ordersRes.error?.message ?? 'Lỗi lấy orders'));
      return;
    }

    final orders = ordersRes.data ?? [];
    if (orders.isEmpty) {
      emit(BillEmpty());
    } else {
      // sắp xếp orders
      final sorted = List<OrderEntity>.from(orders)
        ..sort((a, b) {
          if (a.served != b.served) {
            return a.served ? 1 : -1;
          }
          return a.name.compareTo(b.name);
        });

      emit(BillLoaded(bill, sorted));
    }
  }

  Future<void> _onRequestPayment(
    RequestPaymentEvent event,
    Emitter<BillState> emit,
  ) async {
    final currentState = state;
    if (currentState is BillLoaded) {
      emit(BillLoading());
      try {
        // gọi usecase request payment
        final res = await _requestPaymentUsecase(
          RequestPaymentParams(billId: event.billId, total: event.total),
        );
        // update status booking = paid
        await _checkOutBookingUseCase(params: event.billId);
        if (res is DataSuccess) {
          // Tạo 1 BillEntity mới với requestPayment = true
          final updatedBill = currentState.bill.copyWith(requestPayment: true);
          emit(BillRequestPayment(updatedBill, currentState.orders));
        } else {
          emit(BillFailure('Yêu cầu thanh toán thất bại'));
        }
      } catch (e) {
        emit(BillFailure('Lỗi: $e'));
      }
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<BillState> emit,
  ) async {
    if (state is BillsLoaded) {
      final current = state as BillsLoaded;

      // Optimistic update trên UI
      final updatedBills = current.bills.map((bill) {
        if (bill.id == event.billId) {
          return bill.copyWith(paymented: true);
        }
        return bill;
      }).toList();

      emit(BillsLoaded(updatedBills));

      // Gọi supabase update
      final res = await _updateBillPaymentedUsecase(event.billId, true);
      if (res is DataError) {
        emit(BillFailure(res.error!.message));
      }
    }
  }

  Future<void> _onGetBills(GetBillsEvent event, Emitter<BillState> emit) async {
    emit(BillLoading());

    final billsRes = await _getBillsUsecase();
    List<BillEntity> bills = billsRes.maybeWhen(
      data: (d) => d,
      orElse: () => [],
    );
    // Sắp xếp bills: pending -> requestPayment -> approved
    bills.sort(
      (a, b) => _billStatusPriority(a).compareTo(_billStatusPriority(b)),
    );
    emit(BillsLoaded(bills));
  }
}
