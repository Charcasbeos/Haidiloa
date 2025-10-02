import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:haidiloa/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:haidiloa/features/auth/presentation/bloc/auth_event.dart';
// import 'package:haidiloa/features/bills/presentation/pages/bill_page.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_bloc.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_event.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_state.dart';
import 'package:haidiloa/features/orders/presentation/pages/cart_page.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_event.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_state.dart';

class ListDishesPage extends StatefulWidget {
  final int? tableId;
  const ListDishesPage({super.key, required this.tableId});

  @override
  State<ListDishesPage> createState() => _ListDishesPageState();
}

class _ListDishesPageState extends State<ListDishesPage> {
  @override
  void initState() {
    super.initState();
    context.read<DishBloc>().add(GetListDishesEvent());
    // Khi vào trang, kiểm tra billId hiện tại của OrderBloc
    final orderState = context.read<OrderBloc>().state;
    if (orderState is OrderLoaded && orderState.currentBillId != null) {
      context.read<OrderBloc>().add(GetBillEvent(orderState.currentBillId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffcf4db),
        title: const Text(
          "Menu",
          style: TextStyle(
            color: Color(0xffdc0405),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // nút logout
          // GestureDetector(
          //   onTap: () async {
          //     final shouldLogout = await showDialog<bool>(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: const Text('Xác nhận'),
          //         content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.of(context).pop(false),
          //             child: const Text('Hủy'),
          //           ),
          //           ElevatedButton(
          //             onPressed: () => Navigator.of(context).pop(true),
          //             child: const Text('Đăng xuất'),
          //           ),
          //         ],
          //       ),
          //     );

          //     if (shouldLogout == true) {
          //       context.read<AuthBloc>().add(SignOutEvent());
          //     }
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: Icon(Icons.logout, color: Color(0xffdc0405)),
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.receipt_long, color: Color(0xffdc0405)),
          //   onPressed: () {
          //     final state = context.read<OrderBloc>().state;
          //     int? billId;
          //     if (state is OrderLoaded) billId = state.currentBillId;
          //     if (state is OrderSuccess) billId = state.currentBillId;

          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => BillPage(billId: billId)),
          //     );
          //   },
          // ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, cartState) {
              final tableId = widget.tableId ?? -1;
              print("List page: " + (tableId).toString());

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(tableId: tableId),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_basket,
                        color: Color(0xffdc0405),
                      ),
                      if (cartState is OrderLoaded &&
                          cartState.totalQuantity > 0)
                        Positioned(
                          right: -6,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xfffcf4db),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                '${cartState.totalQuantity}',
                                style: const TextStyle(
                                  color: Color(0xffdc0405),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DishBloc, DishState>(
        builder: (context, state) {
          if (state is DishLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetListDishesSuccess) {
            final dishes = state.listDishesEntity;
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return _card(context, dish);
              },
            );
          } else if (state is GetListDishesFailure) {
            return Center(child: Text('Lỗi: ${state.error.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _card(BuildContext context, DishEntity dish) {
    final cartState = context.watch<OrderBloc>().state;
    final quantity = cartState is OrderLoaded
        ? (cartState.items[dish] ?? 0)
        : 0;
    // Kiểm tra cờ requestPayment trong state

    final requestPayment =
        cartState is OrderLoaded && cartState.requestedPayment;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                dish.imageURL,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat("#,##0", "vi_VN").format(dish.price)} VNĐ',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (requestPayment) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bạn đã yêu cầu thanh toán, không thể giảm món',
                                ),
                              ),
                            );
                            return;
                          }
                          context.read<OrderBloc>().add(RemoveItemEvent(dish));
                        },
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 14)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          if (requestPayment) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bạn đã yêu cầu thanh toán, không thể thêm món mới',
                                ),
                              ),
                            );
                            return;
                          }
                          context.read<OrderBloc>().add(AddItemEvent(dish));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
