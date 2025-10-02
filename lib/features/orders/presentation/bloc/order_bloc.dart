import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/usecase/create_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/create_bill_params.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/update_bill_params.dart';
// import 'package:haidiloa/features/bills/domain/usecase/update_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/update_total_bill_usecase.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/orders/domain/usecase/create_order_params.dart';
import 'package:haidiloa/features/orders/domain/usecase/create_orders_usecase.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_event.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrdersUsecase _createOrdersUsecase;
  final CreateBillUsecase _createBillUsecase;
  final GetBillUsecase _getBillUsecase;
  final UpdateTotalBillUsecase _updateTotalBillUsecase; // thêm update bill

  OrderBloc(
    this._createOrdersUsecase,
    this._createBillUsecase,
    this._updateTotalBillUsecase,
    this._getBillUsecase,
  ) : super(const OrderInitial()) {
    on<AddItemEvent>(_onAddItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ClearOrderEvent>((event, emit) => emit(const OrderInitial()));
    on<SubmitOrdersEvent>(_onSubmitOrder);
    on<BillRequestedPaymentEvent>(_billRequestedPayment);
    on<BillPaymentedEvent>(_billPaymented);
    on<GetBillEvent>(_getBillById);
  }

  void _onAddItem(AddItemEvent event, Emitter<OrderState> emit) {
    final loaded = state is OrderLoaded
        ? state as OrderLoaded
        : const OrderLoaded(items: {});

    final items = Map<DishEntity, int>.from(loaded.items);
    items[event.dish] = (items[event.dish] ?? 0) + 1;

    emit(
      OrderLoaded(
        items: items,
        currentBillId: loaded.currentBillId,
        currentBillTotal: loaded.currentBillTotal,
      ),
    );
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<OrderState> emit) {
    final loaded = state is OrderLoaded
        ? state as OrderLoaded
        : const OrderLoaded(items: {});
    final items = Map<DishEntity, int>.from(loaded.items);
    final current = items[event.dish] ?? 0;
    if (current > 1) {
      items[event.dish] = current - 1;
    } else {
      items.remove(event.dish);
    }

    emit(
      OrderLoaded(
        items: items,
        currentBillId: loaded.currentBillId,
        currentBillTotal: loaded.currentBillTotal,
      ),
    );
  }

  Future<void> _onSubmitOrder(
    SubmitOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    double totalOrders = event.orders.fold<double>(
      0,
      (sum, e) => sum + (e.price * e.quantity),
    );

    int? billId;
    double? currentBillTotal;

    if (state is OrderLoaded) {
      billId = (state as OrderLoaded).currentBillId;
      currentBillTotal = (state as OrderLoaded).currentBillTotal;
    }

    print("Create bill: tableId " + event.tableId.toString());
    print("Create bill: billId " + billId.toString());
    if (billId == null) {
      // tạo bill mới
      final billRes = await _createBillUsecase(
        params: CreateBillParams(tableId: event.tableId, total: totalOrders),
      );
      if (billRes is DataError) {
        emit(OrderFailure(billRes.error!.message));
        return;
      }
      billId = (billRes as DataSuccess<int>).data;
      currentBillTotal = totalOrders;
    } else {
      // update bill hiện có
      final newTotal = (currentBillTotal ?? 0) + totalOrders;
      final updateRes = await _updateTotalBillUsecase(
        UpdateBillParams(billId: billId, total: newTotal),
      );
      if (updateRes is DataError) {
        emit(OrderFailure(updateRes.error!.message));
        return;
      }
      currentBillTotal = newTotal;
    }

    final ordersRes = await _createOrdersUsecase(
      params: CreateOrdersParams(billId: billId!, orders: event.orders),
    );

    if (ordersRes is DataSuccess) {
      emit(
        OrderLoaded(
          items: {},
          currentBillId: billId,
          currentBillTotal: currentBillTotal,
        ),
      );
    } else {
      emit(OrderFailure(ordersRes.error!.message));
    }
  }

  void _billRequestedPayment(
    BillRequestedPaymentEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      emit(
        OrderLoaded(
          items: currentState.items, // vẫn giữ items
          currentBillId: currentState.currentBillId, // giữ billId
          requestedPayment: event.requestPayment, // đánh dấu đã request
        ),
      );
    }
  }

  /// Khi thanh toán thành công (bill.paymented == true)
  void _billPaymented(BillPaymentedEvent event, Emitter<OrderState> emit) {
    // reset toàn bộ
    emit(const OrderInitial());
  }

  void _getBillById(GetBillEvent event, Emitter<OrderState> emit) async {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      // Lấy bill
      final billRes = await _getBillUsecase(event.billId);
      if (billRes is! DataSuccess<BillEntity>) {
        emit(OrderFailure('Không tìm thấy hóa đơn'));
        return;
      }
      final bill = billRes.data!;
      // Update OrderLoaded
      if (bill.paymented) {
        // Da thanh toan thi bill = null luc nay co ban moi
        //-> them mon giam mon binh thuong -> bill moi
        emit(
          OrderLoaded(
            items: currentState.items, // vẫn giữ items
            currentBillId: null, // reset billId
            requestedPayment: false, // reset request
          ),
        );
      }
    }
  }
}
