// import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
// import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

/// Base state cho CartBloc
abstract class OrderState {
  const OrderState();
}

/// Trạng thái bình thường của giỏ hàng
// class OrderLoaded extends OrderState {
//   final Map<DishEntity, int> items;
//   late int? currentBillId;
//   bool requestedPayment;
//   OrderLoaded({
//     required this.items,
//     this.currentBillId,
//     this.requestedPayment = false,
//   });
//   OrderLoaded copyWith({Map<DishEntity, int>? items, bool? requestPayment}) {
//     return OrderLoaded(
//       items: items ?? this.items,
//       requestedPayment: requestPayment ?? this.requestedPayment,
//     );
//   }

//   int get totalQuantity => items.values.fold(0, (sum, q) => sum + q);
// }

/// Đang xử lý đặt hàng
class OrderLoading extends OrderState {
  const OrderLoading();
}

// /// Đặt hàng thành công
// class OrderSuccess extends OrderState {
//   final Map<DishEntity, int> items;
//   final int currentBillId;
//   const OrderSuccess({required this.items, required this.currentBillId});
//   int get totalQuantity => items.values.fold(0, (sum, q) => sum + q);
// }

// order_state.dart
class OrderLoaded extends OrderState {
  final Map<DishEntity, int> items;
  final int? currentBillId;
  final double? currentBillTotal;
  final bool requestedPayment;

  const OrderLoaded({
    required this.items,
    this.currentBillId,
    this.currentBillTotal,
    this.requestedPayment = false,
  });

  /// 👉 Thêm getter tính tổng số lượng món
  int get totalQuantity =>
      items.values.isEmpty ? 0 : items.values.reduce((a, b) => a + b);

  List<Object?> get props => [
    items,
    currentBillId,
    currentBillTotal,
    requestedPayment,
  ];
}

class OrderSuccess extends OrderState {
  final Map<DishEntity, int> items;
  final int? currentBillId;
  final double? currentBillTotal;

  const OrderSuccess({
    required this.items,
    this.currentBillId,
    this.currentBillTotal,
  });

  List<Object?> get props => [items, currentBillId, currentBillTotal];
}

/// Đặt hàng thất bại
class OrderFailure extends OrderState {
  final String message;
  const OrderFailure(this.message);
}

/// Khi mới khởi tạo bloc
class OrderInitial extends OrderState {
  const OrderInitial();
}
