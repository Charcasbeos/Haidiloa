import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_bloc.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_event.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_state.dart';

class CartPage extends StatelessWidget {
  final int? tableId;
  const CartPage({super.key, required this.tableId});

  Future<void> _submitOrder(
    BuildContext context,
    Map<DishEntity, int> cartItems,
  ) async {
    // Lấy list order từ cartItems
    final orders = cartItems.entries.map((entry) {
      final dish = entry.key;
      final qty = entry.value;

      return OrderEntity(
        billId: -1,
        dishId: dish.id!,
        name: dish.name,
        price: dish.price,
        quantity: qty,
        imageURL: dish.imageURL,
        served: false,
      );
    }).toList();

    // Gửi event lên bloc
    context.read<OrderBloc>().add(SubmitOrdersEvent(orders, tableId ?? -1));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đặt hàng thành công')));

          Navigator.pop(context); // quay lại home
        } else if (state is OrderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi đặt hàng: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final cartItems = state is OrderLoaded
            ? state.items
            : <DishEntity, int>{};
        final total = cartItems.entries.fold<double>(
          0,
          (sum, e) => sum + (e.key.price * e.value),
        );
        // Thêm biến loading
        bool loading = false;

        if (state is OrderLoading) {
          loading = true; // đang loading dữ liệu
        }
        print("Cart page: " + (tableId ?? -1).toString());
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffcf4db),
            title: const Text(
              "Order",
              style: TextStyle(
                color: Color(0xffdc0405),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : cartItems.isEmpty
              ? const Center(child: Text('Giỏ hàng trống'))
              : ListView(
                  children: [
                    ...cartItems.entries.map(
                      (entry) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            entry.key.imageURL,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(entry.key.name),
                        subtitle: Text(
                          '${entry.value} x ${NumberFormat("#,##0", "vi_VN").format(entry.key.price)}',
                          style: TextStyle(fontSize: 10),
                        ),
                        trailing: Text(
                          '${NumberFormat("#,##0", "vi_VN").format((entry.key.price * entry.value))} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Tổng cộng (VND)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        '${NumberFormat("#,##0", "vi_VN").format(total)} ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffdc0405),
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () async {
                      await _submitOrder(context, cartItems);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Color(0xffdc0405),
              ),
              child: const Text(
                'Đặt hàng',
                style: TextStyle(fontSize: 16, color: Color(0xfffcf4db)),
              ),
            ),
          ),
        );
      },
    );
  }
}
